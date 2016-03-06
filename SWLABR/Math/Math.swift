import Foundation
import SceneKit

typealias Scalar = CGFloat
typealias Vector3 = SCNVector3
typealias Vector4 = SCNVector4
typealias Quaternion = SCNQuaternion

extension Vector4 {

	init(xyz: Vector3, w: Scalar) {
		x = xyz.x
		y = xyz.y
		z = xyz.z
		self.w = w
	}

	var xyz: Vector3 {
		get {
			return Vector3(x, y, z)
		}
		set (v) {
			x = v.x
			y = v.y
			z = v.z
		}
	}
}

extension Vector3 {

	func cross(v: Vector3) -> Vector3 {
		return Vector3(y * v.z - z * v.y, z * v.x - x * v.z, x * v.y - y * v.x)
	}
}

prefix func -(v: Vector3) -> Vector3 {
	return Vector3(-v.x, -v.y, -v.z)
}

func +(lhs: Vector3, rhs: Vector3) -> Vector3 {
	return Vector3(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
}

func -(lhs: Vector3, rhs: Vector3) -> Vector3 {
	return Vector3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
}

func *(lhs: Vector3, rhs: Vector3) -> Vector3 {
	return Vector3(lhs.x * rhs.x, lhs.y * rhs.y, lhs.z * rhs.z)
}

func *(lhs: Vector3, rhs: Scalar) -> Vector3 {
	return Vector3(lhs.x * rhs, lhs.y * rhs, lhs.z * rhs)
}

func *(v: Vector3, q: Quaternion) -> Vector3 {

	let qv = q.xyz
	let uv = qv.cross(v)
	let uuv = qv.cross(uv)
	return v + (uv * 2 * q.w) + (uuv * 2)
}

prefix func -(q: Quaternion) -> Quaternion {
	return Quaternion(-q.x, -q.y, -q.z, q.w)
}

func +(lhs: Quaternion, rhs: Quaternion) -> Quaternion {
	return Quaternion(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z, lhs.w + rhs.w)
}

func -(lhs: Quaternion, rhs: Quaternion) -> Quaternion {
	return Quaternion(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z, lhs.w - rhs.w)
}

//func *(lhs: Quaternion, rhs: Quaternion) -> Quaternion {
//
//	return Quaternion(
//		lhs.w * rhs.x + lhs.x * rhs.w + lhs.y * rhs.z - lhs.z * rhs.y,
//		lhs.w * rhs.y + lhs.y * rhs.w + lhs.z * rhs.x - lhs.x * rhs.z,
//		lhs.w * rhs.z + lhs.z * rhs.w + lhs.x * rhs.y - lhs.y * rhs.x,
//		lhs.w * rhs.w - lhs.x * rhs.x - lhs.y * rhs.y - lhs.z * rhs.z
//	)
//}

func *(lhs: Quaternion, rhs: Scalar) -> Quaternion {
	return Quaternion(lhs.x * rhs, lhs.y * rhs, lhs.z * rhs, lhs.w * rhs)
}

