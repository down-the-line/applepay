# ApplePay

Quick Start with **ApplePay**

## Getting Started

After download drag and drop ApplePay folder into your project.

### Prerequisites

**Create an apple ID**
**Create Merchant ID**

**Create Apple Sandbox User**
1. First Create a Apple sanbox User and login into a IOS device. 
2. Open you Wallet application to Add a Sanbox account. Remmber Apple Sanbox testing allow only for specific regions. So that firstly you have to set the specific region available for Sanbox ApplePay testing.
3. Now if you will try to add a sanbox card it will ask you **Verify Email Address**. Check your email associated account inbox you will get a mail and verfiy it. I will recommended open it in Incognito window so it cannot link with alreay opened account.
     ****NOTE your email should be valid which you used to create a sanbox User in step 1.****
     
     4. Add sanbox account you find from here.
     
What things you need to install the software and how to install them

### Example

**Step 1** Confirm ApplePaymentDelegate

```extension ViewController: ApplePaymentDelegate {
    var currencyCode: String {
        return "USD"
    }
    
    var countryCode: String {
        return "US"
    }
    
    var merchantIdentifier: String {
        return "com.hardeep.applepay.app"
    }
    
    func applePaymentFailedWithError(error: AppleyPayError) {
        
    }
    
    func didSuccessPayment(payment: ApplePayToken, response: [String : Any]) {
        
    }
    
    func didAuthorizationPayment(payment: ApplePayToken, callback: @escaping (Bool, [String : Any]?) -> Void) {
        // hanlde apple pay token
    }
    
}
```

```

**Step 2** Create ApplePayment object

var applePay: ApplePayment!
func applePayButtonClicked() {
    applePay = ApplePayment(paymentType: .payfort, controller: self)
    applePay.applePayTapped(amount: "100")
}

```

### Installing

A step by step series of examples that tell you how to get a development env running

Say what the step will be

```
Give the example
```

And repeat

```
until finished
```

End with an example of getting some data out of the system or using it for a little demo

## Running the tests

Explain how to run the automated tests for this system

### Break down into end to end tests

Explain what these tests test and why

```
Give an example
```

### And coding style tests

Explain what these tests test and why

```
Give an example
```

## Deployment

Add additional notes about how to deploy this on a live system

## Built With

* [Dropwizard](http://www.dropwizard.io/1.0.2/docs/) - The web framework used
* [Maven](https://maven.apache.org/) - Dependency Management
* [ROME](https://rometools.github.io/rome/) - Used to generate RSS Feeds

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **Billie Thompson** - *Initial work* - [PurpleBooth](https://github.com/PurpleBooth)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Hat tip to anyone whose code was used
* Inspiration
* etc

