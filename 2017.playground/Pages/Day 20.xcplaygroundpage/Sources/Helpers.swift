import Foundation

public struct Coordinates: Hashable {
  public let x: Int
  public let y: Int
  public let z: Int

  public var hashValue: Int { return x.hashValue ^ (y.hashValue << 12) ^ (z.hashValue << 24) }
  public static func ==(lhs: Coordinates, rhs: Coordinates) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
  }

  public init(input: Substring) {
    let numbers = input.components(separatedBy: ",")
    x = Int(numbers[0])!
    y = Int(numbers[1])!
    z = Int(numbers[2])!
  }

  public init(x: Int, y: Int, z: Int) {
    self.x = x
    self.y = y
    self.z = z
  }

  public func distanceFromZero() -> Int {
    return abs(x) + abs(y) + abs(z)
  }

  public func applied(delta: Coordinates) -> Coordinates {
    return Coordinates(x: self.x + delta.x, y: self.y + delta.y, z: self.z + delta.z)
  }
}

public class Particle: Hashable {
  public let id: Int

  public var position: Coordinates
  public var velocity: Coordinates
  public var acceleration: Coordinates

  private static var index: Int = 0

  public init(input: String) {
    self.id = Particle.index
    Particle.index += 1
    let components = input.components(separatedBy: ", ")
    position = Coordinates(input: components[0].dropLast().dropFirst(3))
    velocity = Coordinates(input: components[1].dropLast().dropFirst(3))
    acceleration = Coordinates(input: components[2].dropLast().dropFirst(3))
  }

  public var hashValue: Int { return id.hashValue }
  public static func ==(lhs: Particle, rhs: Particle) -> Bool {
    return lhs.id == rhs.id
  }

  public func process() {
    velocity = velocity.applied(delta: acceleration)
    position = position.applied(delta: velocity)
  }
}

public func closest(particles: [Particle]) -> Particle {
  return particles.min { (left, right) -> Bool in
    let leftA = left.acceleration.distanceFromZero()
    let rightA = right.acceleration.distanceFromZero()
    if leftA != rightA {
      return leftA < rightA
    }
    let leftV = left.velocity.distanceFromZero()
    let rightV = right.velocity.distanceFromZero()
    if leftV != rightV {
      return leftV < rightV
    }
    return left.position.distanceFromZero() < right.position.distanceFromZero()
    }!
}

public func processCollitions(ticks: Int, particles: [Particle]) -> [Particle] {

  var remainingParticles = Set(particles)

  for i in 0..<ticks {
    var collisions: [Coordinates: [Particle]] = [:]
    for particle in remainingParticles {
      let currentParticles = collisions[particle.position] ?? []
      collisions[particle.position] = currentParticles + [particle]
    }

    remainingParticles = remainingParticles.filter { (particle) -> Bool in
      return collisions[particle.position]!.count == 1
    }

    for particle in remainingParticles {
      particle.process()
    }

    if i % 1000 == 0 {
      print("\(i) - \(remainingParticles.count)")
    }
  }

  return Array(remainingParticles)
}
