@propertyWrapper
public struct IO<A> {
	public var get: () -> A
	public var set: (A) -> Void

	@Ref private var didSet: (A) -> Void = { _ in }

	public var value: A {
		get { get() }
		nonmutating set { set(newValue); didSet(newValue) }
	}

	public init(get: @escaping () -> A, set: @escaping (A) -> Void) {
		self.get = get
		self.set = set
	}

	public var wrappedValue: A { get { value } set { value = newValue } }

	public init(_ io: IO) {
		self = io
	}

	public init(_ value: A) {
		var copy = value
		self = IO(get: { copy }, set: { copy = $0 })
	}

	public init(wrappedValue: A) {
		self = IO(wrappedValue)
	}

	public func modify(_ f: (inout A) throws -> Void) rethrows { try f(&value) }

	public var projectedValue: (@escaping (A) -> Void) -> Void {
		{ [_didSet] in _didSet.value = $0 }
	}
}

@propertyWrapper
final class Ref<A> {
	var value: A
	init(_ value: A) { self.value = value }

	convenience init(wrappedValue: A) { self.init(wrappedValue) }
	var wrappedValue: A { get { value } set { value = newValue } }
}
