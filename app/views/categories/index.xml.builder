xml.instruct!
xml.site do
  xml.images do
    if @new_items
      xml.image "", :thumb => "category:NEW", :src => "category:NEW"
      @new_items.each do |item|
        # Show on Flash site, only if not belonging to a client(user)
        xml.image "", :thumb => path_to_url(item.photo.url(:thumb)), :src => path_to_url(item.photo.url(:full))
      end
    end
    
    for category in @categories do
      if (category.enabled.to_i != 0) && (category.user_id == nil)
        xml.image "", :thumb => "category:#{category.name.upcase}", :src => "category:#{category.name.upcase}"
        
        for item in category.items do
          if (item.enabled.to_i != 0)
            xml.image "", :thumb => path_to_url(item.photo.url(:thumb)), :src => path_to_url(item.photo.url(:full))
          end
        end
      end
    end
  end

  xml.videos do
    xml.video "", :id => "Y_GViP2Rc5k"
    xml.video "", :id => "MMlVFa_754o"
    xml.video "", :id => "TxvpctgU_s8"
    xml.video "", :id => "OPKQKX5JWqY"
    xml.video "", :id => "y0LO6v43YCo"
    xml.video "", :id => "gEMAxCAt2eQ"
    xml.video "", :id => "tFxE95Ye4TQ"
    xml.video "", :id => "eyUfJVqMtO0"
  end
end