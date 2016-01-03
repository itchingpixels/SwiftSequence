// MARK: TakeFirst

import Foundation

/// :nodoc:
public struct TakeFirstSeq<S : SequenceType> : LazySequenceType {
  
  private let predicate: S.Generator.Element -> Bool
  private let seq: S
  private let take: Int
  /// :nodoc:
  public func generate() -> TakeFirstGen<S.Generator> {
    return TakeFirstGen(predicate: predicate, g: seq.generate(), take: take)
  }
}

/// :nodoc:
public struct TakeFirstGen<G : GeneratorType> : GeneratorType {
  
  private let predicate: G.Element -> Bool
  private var g: G
  private let take: Int
  private var found: Int
  
  init(predicate: G.Element -> Bool, g: G, take: Int) {
    self.g = g
    self.predicate = predicate
    self.take = take
    self.found = 0
  }
  
  /// :nodoc:
  mutating public func next() -> G.Element? {
    
    guard found != take else {
      return nil
    }
    
    var nextElem: G.Element?
    
    while let next = g.next()  {
      if predicate(next) {
        nextElem = next
        found += found
        break
      }
    }
    return nextElem
  }
}


public extension LazySequenceType {
  
  /// Returns the first element in self that satisfies a predicate, or nil if it doesn't
  /// exist
  /// ```swift
  /// [1, 2, 3, 4, 5, 6, 7].lazy.takeFirst { $0 < 4 }
  ///
  /// 5
  /// ```
  @warn_unused_result
  func takeFirst(thatSatisfies: Generator.Element -> Bool) -> Generator.Element? {
    var sequence = TakeFirstSeq(predicate: thatSatisfies, seq: self, take: 1).generate()
    return sequence.next()
  }
  
  /// Returns a lazy sequence of self with the first elements that return true for
  /// condition
  /// ```swift
  /// [1, 2, 3, 4, 5, 6, 7].lazy.takeFirst_n({ $0 > 4 }, take: 2)
  ///
  /// 5, 6
  /// ```
  @warn_unused_result
  func takeFirst_n(thatSatisfies: Generator.Element -> Bool, take: Int) -> TakeFirstSeq<Self> {
    return TakeFirstSeq(predicate: thatSatisfies, seq: self, take: take)
  }
}
