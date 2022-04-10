require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'

class Scrape
  #DSLのスコープを別けないと警告がでます
  include Capybara::DSL

  def initialize()
    # Capybara.register_driver :poltergeist_debug do |app|
    #   Capybara::Poltergeist::Driver.new(app, :inspector => true)
    # end
    Capybara.register_driver :poltergeist do |app|
        Capybara::Poltergeist::Driver.new(app, {
                          js_errors: false,
                          timeout: 5000,
                        #   debug: true,
                          phantomjs_options: [
                                    '--load-images=no',
                                    '--ignore-ssl-errors=yes',
                                    '--ssl-protocol=any']})
      end
    Capybara.default_driver = :poltergeist
    Capybara.javascript_driver = :poltergeist
  end

  def visit_site
    #ユーザエージェント設定（必要に応じて）
    page.driver.headers = { "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.116 Safari/537.36" }
    # 対象画面
    visit('http://localhost:4567/input')
    #スクリーンショットで保存
    page.save_screenshot('screenshot/1.png', :full => false)
    page.first('input').native.send_key('Akito Yoshimura')
    page.find('textarea').native.send_key('free comment')
    
    page.save_screenshot('screenshot/2.png', :full => false)
    
    page.find('input.btn').click
    page.save_screenshot('screenshot/3.png', :full => true)
    #within(:xpath, "//*[@id='toipcsfb']/div[1]/ul[1]") do
    #Nokogirオブジェクトの作成
    # doc = Nokogiri::HTML.parse(page.html)
    # puts doc.textarea
    # puts doc
  end
end

scrape = Scrape.new
scrape.visit_site