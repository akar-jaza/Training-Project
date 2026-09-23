import XCTest

final class Products_Screen_UITests: XCTestCase {
    
    private let app = XCUIApplication()
    
    private func openProducts() {
        let productButton = app.buttons["productButtonCell"]
        XCTAssertTrue(productButton.waitForExistence(timeout: 5))
        productButton.tap()
    }

    func testUserCanOpenProductsScreen() {
        app.launch()
        
        let productButton = app.buttons["productButtonCell"]
        XCTAssertTrue(productButton.waitForExistence(timeout: 5))
        
        productButton.tap()
    }
    
    func testUserCanTapProductCellListItem() {
        app.launch()
        
        let productButton = app.buttons["productButtonCell"]
        XCTAssertTrue(productButton.waitForExistence(timeout: 5))
        
        let product = app.tables.cells["productCell-1"]
        XCTAssertTrue(product.waitForExistence(timeout: 10))
        product.tap()
        
        XCTAssertTrue(app.staticTexts["productDetailTitle"]
            .waitForExistence(timeout: 5))
        
    }
    
    func testUserCanLongPressAndDeleteProduct() {
        app.launch()
        openProducts()
        
        let productCell = app.tables.cells["productCell-1"]
        XCTAssertTrue(productCell.waitForExistence(timeout: 10))
        
        productCell.press(forDuration: 1.0)
        
        let deleteButton = app.buttons["Delete"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 3))
        
        deleteButton.tap()
        
        XCTAssertTrue(productCell.waitForNonExistence(timeout: 5))
    }
    
    func testUserCanCreateProduct() {
        app.launch()
        openProducts()
        
        let openFormButton = app.buttons["OpenCreateProductFormButton"]
        openFormButton.press(forDuration: 0.50)
        XCTAssertTrue(openFormButton.waitForExistence(timeout: 3))
        
        let formSheet = app.otherElements["productFormSheet"]
        XCTAssertTrue(formSheet.waitForExistence(timeout: 3))
        
        let titleFormField = app.textFields["titleFormField"]
        let descriptionFormField = app.textFields["descriptionFormField"]
        let priceFormField = app.textFields["priceFormField"]
        
        titleFormField.tap()
        titleFormField.typeText("Product 1")
        
        descriptionFormField.tap()
        descriptionFormField.typeText("Descrption")
        
        priceFormField.tap()
        priceFormField.typeText("1213")
        
        let createProductButton = app.buttons["createProductButton"]
        createProductButton.press(forDuration: 0.50)
        
        XCTAssertTrue(formSheet.waitForNonExistence(timeout: 3))
    }
    

    func testUserCanUpdateProduct() {
        app.launch()
        openProducts()
        
        let productCell = app.tables.cells["productCell-1"]
        XCTAssertTrue(productCell.waitForExistence(timeout: 10))
        
        productCell.press(forDuration: 1.0)
        
        let editButton = app.buttons["Edit"]
        editButton.press(forDuration: 1)
        
        let formSheet = app.otherElements["productFormSheet"]
        XCTAssertTrue(formSheet.waitForExistence(timeout: 3))
        
        let titleFormField = app.textFields["titleFormField"]
        let descriptionFormField = app.textFields["descriptionFormField"]
        let priceFormField = app.textFields["priceFormField"]
        
        
        let clearTitleFormField = titleFormField.coordinate(
            withNormalizedOffset: CGVector(dx: 0.94, dy: 0.5)
        )
        clearTitleFormField.tap()
        titleFormField.typeText("New Product")

        descriptionFormField.tap()
        let clearDescriptionFormField = descriptionFormField.coordinate(
            withNormalizedOffset: CGVector(dx: 0.94, dy: 0.5)
        )
        clearDescriptionFormField.tap()
        descriptionFormField.typeText("New Description")
        
        priceFormField.tap()
        let clearPriceFormField = priceFormField.coordinate(
            withNormalizedOffset: CGVector(dx: 0.94, dy: 0.5)
        )
        clearPriceFormField.tap()
        priceFormField.typeText("1234")

        
        let createProductButton = app.buttons["updateProductButton"]
        createProductButton.press(forDuration: 0.50)
        
        XCTAssertTrue(formSheet.waitForNonExistence(timeout: 3))
    }
}
