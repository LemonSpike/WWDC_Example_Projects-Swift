//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

struct A { var data: Int = 2 }

var a = A()
var b = a
var c = b
c.data=10
b.data=5
print(a.data)
print(c.data)

if a.data is String {
    print("hi")
} else {
    print("bye")
}