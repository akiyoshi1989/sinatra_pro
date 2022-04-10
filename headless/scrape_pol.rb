require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'

class Scrape

  include Capybara::DSL

  def initialize()
    Capybara.register_driver :poltergeist do |app|
        Capybara::Poltergeist::Driver.new(app, {
                          js_errors: false,
                          timeout: 5000,
                        #   debug: true, コメント解除でコンソール上に処理状況が吐き出される
                          phantomjs_options: [
                                    '--load-images=no',
                                    '--ignore-ssl-errors=yes',
                                    '--ssl-protocol=any']})
      end
    Capybara.default_driver = :poltergeist
  end


  def visit_input_page
    #ユーザエージェント設定（必要に応じて）
    page.driver.headers = { "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.116 Safari/537.36" }
    # 対象画面を開く
    visit('http://localhost:4567/input')

    #スクリーンショットで保存
    page.save_screenshot(rtn_ss_name('scrape'))

    # 入力フォームに値をセット
    page.first('input').native.send_key('akiyoshi')
    page.select('30', :from => 'age')
    page.find('textarea').native.send_key('細かい操作は対象画面の構造が変わると、動かなくなります（泣）')
    
    page.save_screenshot(rtn_ss_name('scrape'))
    
    page.find('input.btn').click
    
    page.save_screenshot(rtn_ss_name('scrape'))

    # page.find('input.btn').clickと指定の仕方は違うが、やってることは同じ。
    page.click_button('submit')
    page.save_screenshot(rtn_ss_name('scrape'), :full => false)
    page.save_screenshot(rtn_ss_name('scrape'), :full => true)

    # NokogiriでHTMLをパースする。今回は使っていないが、本格的にスクレイピングする場合は本命。
    doc = Nokogiri::HTML.parse(page.html)
    puts doc.title
  end
end

# スクリーンショット名（ファイル名重複時の上書き防止）を作る
def rtn_ss_name(base_file_name)
  dir_name = './screenshot'

  unless Dir.exist?(dir_name)
    Dir.mkdir(dir_name)
  end
  
  i = 1
  loop{
    file_name = "#{dir_name}/#{base_file_name}_#{i}.png"
    unless File.exist?(file_name)
      return file_name
    end
    i += 1
  }
end

# 実行部
scrape = Scrape.new
scrape.visit_input_page