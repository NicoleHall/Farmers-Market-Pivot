FactoryGirl.define do
  factory :artist do
    first_name
    last_name
    factory :artist_with_items do
      transient do
        item_count 2
      end
      after(:create) do |artist, evaluator|
        create_list(:item, evaluator.item_count, artist: artist)
      end
    end
  end

  factory :item do
    price
    description "This is a painting of Batman."
    title
    image_path "https://s-media-cache-ak0.pinimg.com/236x/ac/79/ec/ac79ecfd60f82e28cabdfb8f1dc10df4.jpg"
    artist
    category
  end

  factory :category do
    name
    factory :category_with_items do
      transient do
        item_count 2
      end
      after(:create) do |category, evaluator|
        create_list(:item, evaluator.item_count, category: category)
      end
    end
  end

  factory :user do
    first_name
    last_name
    username "user"
    password "password"
    role 0

    factory :admin do
      username "admin"
      role 2
    end
  end

  sequence :name, %w(a b c).cycle do |n|
    "name#{n}"
  end

  sequence :first_name do |n|
    "firstname#{n}"
  end

  sequence :last_name do |n|
    "lastname#{n}"
  end

  sequence :title do |n|
    "title#{n}"
  end

  sequence :price do |n|
    0 + n
  end
end
