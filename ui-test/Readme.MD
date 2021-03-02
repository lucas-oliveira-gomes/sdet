###UI Test
- Access `http://demo.cs-cart.com;`
- Search for any product;
- Access this product on the table grid;
- Add this product to the cart;
- Check the item on the cart and total price;
- Do the Checkout;
- Select the “Phone Order” Payment;
- Proceed with the order;

#### How to execute
 - Clone this repository:
 `git clone https://github.com/lucas-oliveira-gomes/sdet.git`
 
 - Download and install the correct chromedriver for your version of Google Chrome from `https://chromedriver.chromium.org/downloads`
 
 - Navigate to the api-test folder
  `cd sdet\ui-test`
 
 - Install dependencies:
  `bundle install`
  
   - Execute the file:
   `ruby UI-Test.rb`