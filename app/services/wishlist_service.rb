class WishlistService

  attr_accessor :group, :current_person, :group_person

  def initialize(group, current_person)
    @group          = group
    @current_person = current_person
    @group_person   = current_person.group_person(group)
  end

  def update(description, items)
    result_description = update_description(description)
    result_items       = update_list(items)

    if result_description[:success] && result_items[:success]
      { success: true, message: t('updated_wishlist') }
    else
      errors = []
      errors << result_description[:message] if result_description[:message]
      errors = errors + result_items[:message] if result_items[:message]

      { success: false, message: errors.join(', ') }
    end
  end

  def update_description(description)
    begin
      group_person.wishlist_description = description
      group_person.save!
      { success: true }
    rescue => error
      { success: false, message: error.message }
    end
  end

  def update_list(items)
    errors = []

    if items && items.any?
      items.each do |item|
        begin
          name_or_url = item[:name_or_url]
          unless name_or_url.empty?
            if name_or_url.include?('http://') || name_or_url.include?('https://')
              page = MetaInspector.new(name_or_url)

              WishlistItem.create!(
                group_person: group_person,
                name_or_url: name_or_url,
                comments: item[:comments],
                link_title: page.best_title,
                link_description: page.description,
                image: get_image(page)
              )
            else
              WishlistItem.create!(
                group_person: group_person,
                name_or_url: name_or_url,
                comments: item[:comments]
              )
            end
          end
        rescue => error
          message = error.message.size > 100 ? error.message[0..100] + '...' : error.message
          errors << message
        end
      end
    end

    errors.empty? ? { success: true } : { success: false, message: errors }

  end

  private

  def get_image(page)
    begin
      image = page.images.best
    rescue
      image = nil unless valid_image?(image)
    end
  end

  def valid_image?(image)
    image && image.size <= 255 && remote_file_exists?(image)
  end

  def remote_file_exists?(url)
    url = URI.parse(url)
    Net::HTTP.start(url.host, url.port) do |http|
      return http.head(url.request_uri)['Content-Type'].start_with? 'image'
    end
  end

end