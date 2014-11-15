package proto;

/**
 * An Immutable Tuple class(es) implementation.
 * 
 * @author Julien Polo
 */

/**
 * Abstract base class (no constructor)
 */
class Tuple {
  
  /**
   * The length represent the number of parameters (i.e. arity)
   */
  public var length(get, never): Int;
  
  //
  //  Getter / Setter
  //
  
  /**
   * Return the `index` element of the tuple.
   * The tuple indexes are starting from 1.
   * 
   * @param index
   * @return
   */
  public function element(index: Int): Dynamic {
    if (index <= 0 || index > length) indexOutOfBound(index);
    return Reflect.field(this, "_" + index);
  }
  
  function get_length() {
    return 0;
  }
  
  //
  //  Iterable
  //
  
  /**
   * Return new iterator for this tuple
   * 
   * @return
   */
  public function iterator(): Iterator<Dynamic> {
    var arity = length;
    var i = 1;
    return {
      hasNext: function() {
        return i <= arity;
      },
      next: function() {
        return element(i++);
      }
    };
  }
  
  //
  //  Internal
  //
  
  /**
   * Return true if `other` is a tuple with same length
   * and all elements are equals.
   * 
   * @param other
   * @return
   */
  public function equals(other: Dynamic): Bool {
    var isEqual = false;
    if (Std.is(other, Type.getClass(this))) {
      var tuple: Tuple = cast other;
      var arity = length;
      if (arity == tuple.length) {
        isEqual = true;
        for (i in 1...arity + 1) {
          //if (!element(i).equals(tuple.element(i)) {
          if (element(i) != tuple.element(i)) {
            isEqual = false;
            break;
          }
        }
      }
    }
    return isEqual;
  }
  
  /*public function hashCode() {
    var hash = 0;
    for (value in this) {
      hash = 31 * hash + value.hashCode();
    }
    return hash;
  }*/
  
  /**
   * String representation
   */
  public function toString() {
    var s = new StringBuf();
    s.add("(");
    s.add(Std.string(element(1)));
    for (i in 2...length + 1) {
      s.add(",");
      s.add(Std.string(element(i)));
    }
    s.add(")");
    return s.toString();
  }
  
  @:extern inline
  function indexOutOfBound(index: Int) {
    return throw "IndexOutOfBound";
  }
  
}

/**
 * Tuple with two parameters
 */
class Tuple2 < A, B > 
  extends Tuple {
  
  public var _1(default, null): A;
  public var _2(default, null): B;
  
  public function new(_1: A, _2: B) {
    this._1 = _1;
    this._2 = _2;
  }
  
  override function get_length() {
    return 2;
  }
}

/**
 * Tuple with three parameters
 */
class Tuple3 < A, B, C> 
  extends Tuple {

  public var _1(default, null): A;
  public var _2(default, null): B;
  public var _3(default, null): C;
  
  public function new(_1: A, _2: B, _3: C) {
    this._1 = _1;
    this._2 = _2;
    this._3 = _3;
  }
  
  override function get_length() {
    return 3;
  }
  
}

/**
 * Tuple with four parameters
 */
class Tuple4 < A, B, C, D> 
  extends Tuple {
    

  public var _1(default, null): A;
  public var _2(default, null): B;
  public var _3(default, null): C;
  public var _4(default, null): D;
  
  public function new(_1: A, _2: B, _3: C, _4: D) {
    this._1 = _1;
    this._2 = _2;
    this._3 = _3;
    this._4 = _4;
  }
  
  override function get_length() {
    return 4;
  }
  
}

/**
 * Tuple with five parameters
 */
class Tuple5 < A, B, C, D, E>  
  extends Tuple {
    
  public var _1(default, null): A;
  public var _2(default, null): B;
  public var _3(default, null): C;
  public var _4(default, null): D;
  public var _5(default, null): E;
  
  public function new(_1: A, _2: B, _3: C, _4: D, _5: E) {
    this._1 = _1;
    this._2 = _2;
    this._3 = _3;
    this._4 = _4;
    this._5 = _5;
  }
  
  override function get_length() {
    return 5;
  }
  
}