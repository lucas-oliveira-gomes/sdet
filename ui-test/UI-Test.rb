require 'selenium-webdriver'
require 'test-unit'

class DemoCSCartCheck < Test::Unit::TestCase

    def setup        
        @driver = Selenium::WebDriver.for :chrome
        @url = "https://demo.cs-cart.com/"
        @driver.manage.timeouts.implicit_wait = 30
    end

    def test_search_a_item_add_to_cart_and_checkout
        @driver.get @url       

        #Get the Product Search Bar
        @search_bar = @driver.find_element(:id, 'search_input')
        
        #Search for a product
        product_name = 'Collegiate 72 Tee'
        @search_bar.send_keys(product_name)       

        #Submit the request
        @search_bar.submit
        
        #Get Item Found
        item_found = @driver.find_element(:xpath, "//div[@class='ty-grid-list__item ty-quick-view-button__wrapper ty-grid-list__item--overlay']")
        item_value = @driver.find_element(:xpath,"//span[@class='ty-price-num'][2]").text

        #Check if the found product name matches
        assert(item_found.text.include?(product_name), "This was expected to be true")
        assert(!item_value.nil?, "This expects the value to not be null")
        
        #Access the item on table grid
        @driver.action.move_to(item_found).perform        
        data_in_the_item = @driver.find_element(:xpath, "//a[@class='ty-btn ty-btn__secondary ty-btn__big cm-dialog-opener cm-dialog-auto-size']")   
        @driver.action.click(data_in_the_item).perform

        #Add item to cart
        @driver.find_element(:xpath, "//button[@class='ty-btn__primary ty-btn__big ty-btn__add-to-cart cm-form-dialog-closer ty-btn']").click

        #Go to cart        
        hover_box = @driver.find_elements(:xpath, "//div[@class='cm-notification-content cm-notification-content-extended notification-content-extended  cm-auto-hide']")
        maxRetry = 0        
        loop do
            if(hover_box.length > 0)
                maxRetry+=1
                hover_box = @driver.find_elements(:xpath, "//div[@class='cm-notification-content cm-notification-content-extended notification-content-extended  cm-auto-hide']")               
                sleep 1                        
            end
            break if maxRetry > 15 || hover_box.length == 0
        end        

        cart_link = @driver.find_element(:xpath, "//div[@class='ty-dropdown-box__title cm-combination']//a").attribute("href")  
        
        @driver.get cart_link
        
        qtd_products_in_cart = @driver.find_elements(:xpath, "//div[@id='cart_items']/table//tr//a[@class='ty-cart-content__product-title']").length()
        found_product_name = @driver.find_element(:xpath, "//div[@id='cart_items']/table//tr//a[@class='ty-cart-content__product-title']").text
        
        in_cart_item_value = @driver.find_element(:xpath,"//span[@class='price'][2]").text        
        cart_total_value = @driver.find_element(:id, 'sec_cart_total').text

        assert_equal(qtd_products_in_cart, 1, "This expects to find one poduct in cart")
        assert_equal(found_product_name, product_name, "This expects the product name and the found product name to be the same")

        assert_equal(item_value, in_cart_item_value, "This expects the product value and in cart product value to be the same")
        assert_equal(item_value, cart_total_value, "This expects the the total cart value to be equals to the value of a single unit of the product")

        #Go to checkout page
        checkout_link = @driver.find_element(:xpath, "//div[@class='buttons-container ty-cart-content__top-buttons clearfix']/div[@class='ty-float-right ty-cart-content__right-buttons']/a").attribute("href")
        @driver.get checkout_link

        #Do the checkout
        @driver.find_element(:id, 'litecheckout_s_address').send_keys('Sample Addrress')
        @driver.find_element(:id, 'litecheckout_s_zipcode').send_keys('12345678')
        @driver.find_element(:id, 'litecheckout_fullname').send_keys('Sample Full Name')
        @driver.find_element(:id, 'litecheckout_phone').send_keys('5511123456789')
        @driver.find_element(:id, 'litecheckout_email').send_keys('sampleemail@mailinator.com')
        
        payment_checkbox =  @driver.find_element(:id, 'radio_2')
        assert(!payment_checkbox.nil?, 'This expects this element should not be null')
        @driver.execute_script('arguments[0].click()', payment_checkbox)        
        
        maxRetry=0
        loop do
            sleep 1
            maxRetry+=1
            break if maxRetry > 5
        end
        @driver.script("document.getElementsByName('accept_terms')[0].click()")

        #Unfortunately CAPTCHA  is enabled so it can't be automated
        @driver.script("document.getElementById('recaptcha-anchor').click()")

        place_order = @driver.find_element(:id, 'litecheckout_place_order')
        place_order.click

        success_message = @driver.find_elements(:xpath, "//div[@class='ty-checkout-complete__order-success']")

        assert_equal(success_message.length, 1)        
    end

    def tear_down
        @driver.quit
    end
end