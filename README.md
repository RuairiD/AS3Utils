AS3Utils
========

This repo contains a bunch of classes I use in AS3 projects. I'm still working on getting everything fit for public display but here's what's available so far.

### Object Pooling

I wrote classes for object pooling out of necessity. I made a splitscreen game called *Aether Quest* which involved a lot of enemy and item spawning. Rather than manage object pooling independently for each class, it made more sense to use a centralised pool. As a result, with a little planning, the code can be reused in any AS3 project.

#### Setup

`ObjectPool` needs to be setup before it can be used by calling 
```
ObjectPool.init();
```
You can do this anywhere; I setup all my static utilities either in the constructor of `Main.as` or, if I'm using Starling, the constructor of the entry class for the Starling object.

#### Pooling and Recycling

Adding an object to the pool is easy. When an object is no longer needed, it can be pooled using

```
ObjectPool.addToPool(object)
```

I use `destroy` functions in my classes which perform any clean-up (removing listeners etc.) before calling `addToPool` on `this`.

```
public function destroy():void
{
  //destroy code
	ObjectPool.addToPool(this);
}
```

Recycling an object from the pool is a little trickier. Rather than using the `new` keyword and creating a new instance of a class, use `ObjectPool` to create new objects. Here's an example of creating an instance of `PoolableClass` with `new`:

```
var a:PoolableClass = new PoolableClass("a", 1);
```
...and the same code but using `ObjectPool`:

```
var a:PoolableClass = ObjectPool.createFromClass(PoolableClass, ["a", 1]) as PoolableClass;
```

`createFromClass` takes two arguments: the object's `Class` and an Array of arguments. A class can only be poolable if it has an `init` function. This function should have similar functionality to a constructor; I tend to call `init` from my constructors and leave all of the class's setup code in `init`.

```
public function PoolableClass(f:String, b:int) 
{
	init(f, b);
}

public function init(f:String, b:int):void
{
	foo = f;
	bar = b;
}
```

The Array of arguments should be treated the same as passing arguments to a constructor, just in an Array instead of in parentheses.

Finally, `createFromClass` returns an `Object`, so it needs to be cast to a `PoolableClass` using the `as` keyword.

#### Gotchas

* This code won't be able to pool AS3's native libraries, so it's important to be smart and reuse memory intensive objects (e.g. anything in `flash.display.*`) manually.
* Make sure objects are completely idle before they're pooled. Remove listeners, remove it from the stage etc.. If you don't, you can end up with some ugly side effects.
* Pooled objects will not be garbage collected. You can end up with a massive pool of objects which aren't being used and are just sitting in memory. (I'll be fixing this pretty soon.)
