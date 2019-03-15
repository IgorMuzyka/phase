
import Files
import SwiftShell
import Foundation

class Temp {

	let name: String
	var folder: Folder? = nil

	convenience init() {
		let uniqueIdentifier = UUID().uuidString.replacingOccurrences(of: "-", with: "")
		self.init(name: uniqueIdentifier)
	}

	init(name: String) {
		self.name = name
	}

	@discardableResult
	func create() -> Temp {
		folder = try! Folder.temporary.createSubfolderIfNeeded(withName: name)
		return self
	}

	@discardableResult
	func switchTo() -> Temp {
		guard let path = folder?.path else {
			return self
		}

		SwiftShell.main.currentdirectory = path
		return self
	}

	@discardableResult
	func execute(_ closure: (Temp) -> Void) -> Temp {
		switchTo()
		closure(self)
		return self
	}

	@discardableResult
	func remove() -> Temp {
		if Folder.temporary.containsSubfolder(named: name) {
			try! folder?.delete()
		}
		return self
	}
}
