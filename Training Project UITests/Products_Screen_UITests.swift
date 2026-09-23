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
}
