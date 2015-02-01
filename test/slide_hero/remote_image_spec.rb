require 'minitest_helper'
require 'webmock/minitest'

module SlideHero
  describe Image do

    after do
      image = File.join(Dir.pwd,"test","tmp","images", "le_troll.png")
      File.delete(image)
    end

    it "downloads remote file, and serves it locally" do
      stub_request(:get, "http://example.com/troll.png").
        to_return(body: File.open(File.join(Dir.pwd,"test","fixtures","images", "image.png")))
      destination_folder = File.join(Dir.pwd,"test","tmp","images")
      image = RemoteImage.new("http://example.com/troll.png", "Troll", width: 280, height: 326, as: "le_troll", destination: destination_folder)
      image.compile.must_equal %{<img width="280" height="326" src="images/le_troll.png" alt="Troll">}
      assert_requested :get, "http://example.com/troll.png"
    end
  end
end
