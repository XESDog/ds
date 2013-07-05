﻿package;

import de.polygonal.ds.ArrayedDeque;
import de.polygonal.ds.Cloneable;
import de.polygonal.ds.Deque;
import de.polygonal.ds.LinkedDeque;

class TestLinkedDeque extends haxe.unit.TestCase
{
	inline static var BLOCK_SIZE = 4;
	
	function createDequeInt(size = BLOCK_SIZE)
	{
		return new LinkedDeque<Int>();
	}
	
	function createDequeFoo(size = BLOCK_SIZE)
	{
		return new ArrayedDeque<E>(size);
	}
	
	function testAdjacent()
	{
		//[x, x, x, h] [t, x, x, ]
		var d = createDequeInt();
		
		d.pushBack(0);
		d.pushBack(1);
		d.pushBack(2);
		d.popFront();
		d.popFront();
		d.popFront();
		
		assertTrue(d.isEmpty());
		
		d.pushFront(3);
		d.pushBack(4);
		
		assertEquals(3, d.getFront(0));
		assertEquals(4, d.getBack(0));
	}
	
	function testFill()
	{
		var d = createDequeInt();
		d.fill(9, 10);
		assertEquals(10, d.size());
		for (i in 0...10) assertEquals(9, d.getFront(i));
		
		var d = createDequeInt(8);
		for (i in 0...3) d.pushBack(i);
		
		d.fill(9, 1);
		d.fill(9, 2);
		d.fill(9, 3);
		
		var d = createDequeInt(4);
		for (i in 0...20) d.pushBack(i);
		d.fill(99);
		assertEquals(20, d.size());
		for (i in 0...20)
			assertEquals(99, d.getFront(i));
			
		var d = createDequeInt(4);
		for (i in 0...30) d.pushBack(i);
		d.fill(99);
		assertEquals(30, d.size());
		for (i in 0...30)
			assertEquals(99, d.getFront(i));
			
		for (s in 0...15)
		{
			var d = createDequeInt(4);
			for (i in 0...20) d.pushBack(i);
			
			d.fill(99, s);
			for (i in 0...s)
			{
				assertEquals(99, d.getFront(i));
			}
			
		}
	}
	
	function testClear()
	{
		var d = createDequeInt();
		d.fill(9, 10);
		d.clear(true);
		assertTrue(d.isEmpty());
		assertEquals(0, d.size());
	}
	
	function testIndexOf()
	{
		var d = createDequeInt();
		var s = 0;
		for (i in 0...20)
			d.pushFront(i);
		
		for (i in 0...20)
		{
			assertEquals(20 - 1 - i, d.indexOfFront(i));
			assertEquals(i, d.indexOfBack(i));
		}
	}
	
	function testGetFront()
	{
		var d = createDequeInt();
		var s = 0;
		for (i in 1...20)
		{
			d.pushFront(i);
			s++;
			
			var j = s;
			var k = 0;
			while (j > 0)
			{
				assertEquals(j, d.getFront(k));
				k++;
				j--;
			}
		}
		
		var d = createDequeInt();
		var s = 0;
		for (i in 1...20)
		{
			d.pushBack(i);
			s++;
			var j = 0;
			while (j < s)
			{
				assertEquals(j+1, d.getFront(j));
				j++;
			}
		}
	}
	
	function testGetBack()
	{
		var d = createDequeInt();
		var s = 0;
		for (i in 1...20)
		{
			d.pushFront(i);
			s++;
			var j = 0;
			while (j < s)
			{
				assertEquals(j+1, d.getBack(j));
				j++;
			}
		}
		
		var d = createDequeInt();
		var s = 0;
		for (i in 1...4)
		{
			d.pushBack(i);
			s++;
			var j = s;
			var k = 0;
			while (j > 0)
			{
				assertEquals(j, d.getBack(k));
				j--;
				k++;
			}
		}
	}
	
	function testClone()
	{
		var s = 1;
		while (s < 20)
		{
			var d = createDequeInt();
			var i = 0;
			for (k in 0...s) d.pushBack(i++);
			
			var c:Deque<Int> = cast d.clone(true);
			assertEquals(d.size(), c.size());
			i = 0;
			var z = 0;
			for (x in c)
			{
				assertEquals(x, i++);
				z++;
			}
			assertEquals(s, z);
			s++;
		}
		
		var s = 1;
		while (s < 20)
		{
			var d = createDequeFoo();
			var i = 0;
			for (k in 0...s) d.pushBack(new E(i++));
			
			var c:Deque<E> = cast d.clone(false);
			assertEquals(d.size(), c.size());
			i = 0;
			var z = 0;
			for (x in c)
			{
				assertEquals(x.id, i++);
				z++;
			}
			assertEquals(s, z);
			s++;
		}
		
		var copier = function(x:E)
		{
			return new E(x.id);
		}
		
		var s = 1;
		while (s < 20)
		{
			var d = createDequeFoo();
			var i = 0;
			for (k in 0...s) d.pushBack(new E(i++));
			
			var c:Deque<E> = cast d.clone(false, copier);
			assertEquals(d.size(), c.size());
			i = 0;
			var z = 0;
			for (x in c)
			{
				assertEquals(x.id, i++);
				z++;
			}
			assertEquals(s, z);
			s++;
		}
	}
	
	function testIterator()
	{
		var s = 1;
		while (s < 20)
		{
			var d = createDequeInt();
			var i = 0;
			for (k in 0...s) d.pushBack(i++);
			
			i = 0;
			var z = 0;
			for (x in d)
			{
				assertEquals(x, i++);
				z++;
			}
			assertEquals(s, z);
			s++;
		}
	}
	
	function testIteratorRemove()
	{
		for (i in 0...5)
		{
			var l = new de.polygonal.ds.LinkedDeque<Int>();
			var set = new de.polygonal.ds.ListSet<Int>();
			for (j in 0...5)
			{
				l.pushBack(j);
				if (i != j) set.set(j);
			}
			
			var itr = l.iterator();
			while (itr.hasNext())
			{
				var val = itr.next();
				if (val == i) itr.remove();
			}
			
			while (!l.isEmpty())
			{
				assertTrue(set.remove(l.popBack()));
			}
			assertTrue(set.isEmpty());
			assertEquals(null, untyped l._head);
			assertEquals(null, untyped l._tail);
		}
		
		var l = new de.polygonal.ds.LinkedDeque<Int>();
		for (j in 0...5) l.pushBack(j);
		
		var itr = l.iterator();
		while (itr.hasNext())
		{
			itr.next();
			itr.remove();
		}
		assertTrue(l.isEmpty());
		assertEquals(null, untyped l._head);
		assertEquals(null, untyped l._tail);
	}
	
	function testContains()
	{
		var s = 1;
		while (s < 20)
		{
			var d = createDequeInt();
			var i = 0;
			for (k in 0...s) d.pushBack(i++);
			
			i = 0;
			for (x in d)assertTrue(d.contains(i++));
			s++;
		}
	}
	
	function testToArray()
	{
		//2
		var d = createDequeInt();
		for (i in 0...2) d.pushBack(i);
		var a = d.toArray();
		for (i in 0...a.length)
			assertEquals(a[i], d.popFront());
		assertEquals(2, a.length);
		
		//4
		var d = createDequeInt();
		for (i in 0...4) d.pushBack(i);
		var a = d.toArray();
		for (i in 0...a.length)
			assertEquals(a[i], d.popFront());
		assertEquals(4, a.length);
		
		//16
		var d = createDequeInt();
		for (i in 0...16) d.pushBack(i);
		var a = d.toArray();
		for (i in 0...a.length)
			assertEquals(a[i], d.popFront());
		assertEquals(16, a.length);
	}
	
	function testRemoveCase1()
	{
		//work to back case2
		var d = createDequeInt(4);
		d.pushBack(0);
		d.pushBack(1);
		d.pushBack(2);
		d.pushBack(3);
		
		d.remove(2);
		var c = 0;
		var data = [0, 1, 3];
		for (x in d)
		{
			c++;
			assertEquals(x, data.shift());
		}
		assertEquals(3, c);
		
		d.remove(3);
		var c = 0;
		var data = [0, 1];
		for (x in d)
		{
			c++;
			assertEquals(x, data.shift());
		}
		assertEquals(2, c);
		
		//work to back case2
		var d = createDequeInt();
		for (i in 0...20)
			d.pushBack(i);
		d.remove(2);
		var c = 0;
		var data = [0, 1, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19];
		for (x in d)
		{
			c++;
			assertEquals(x, data.shift());
		}
		assertEquals(19, c);
		
		//work to head case2
		var d = createDequeInt(8);
		d.pushBack(0);
		d.pushBack(1);
		d.pushBack(2);
		d.pushBack(3);
		d.pushBack(4);
		d.pushBack(5);
		d.pushBack(6);
		d.pushBack(7);
		d.pushBack(8);
		d.remove(2);
		var c = 0;
		var data = [0, 1, 3, 4, 5, 6, 7, 8];
		for (x in d)
		{
			c++;
			assertEquals(x, data.shift());
		}
		assertEquals(8, c);
		
		var d = createDequeInt(8);
		d.pushBack(0);
		d.pushBack(1);
		d.pushBack(2);
		d.pushBack(3);
		d.pushBack(4);
		
		d.remove(0); //block0, head++
		assertEquals(4, d.size());
		var i = 1;
		var c = 0;
		for (x in d)
		{
			c++;
			assertEquals(x, i++);
		}
		assertEquals(4, c);
		
		d.remove(4); //block0, tail--
		assertEquals(3, d.size());
		var i = 1;
		var c = 0;
		for (x in d)
		{
			c++;
			assertEquals(x, i++);
		}
		assertEquals(3, c);
		
		d.remove(2);
		assertEquals(2, d.size());
		var i = 1;
		var c = 0;
		var data = [1, 3];
		for (x in d)
		{
			c++;
			assertEquals(x, data.shift());
		}
		assertEquals(2, c);
		
		d.remove(1);
		assertEquals(1, d.size());
		var i = 1;
		var c = 0;
		var data = [3];
		for (x in d)
		{
			c++;
			assertEquals(x, data.shift());
		}
		assertEquals(1, c);
		
		d.remove(3);
		assertEquals(0, d.size());
	}
	
	function testRemoveCase2()
	{
		var d = createDequeInt(4);
		d.pushBack(0);
		d.pushBack(1);
		d.pushBack(2);
		d.pushBack(3);
		d.pushBack(4);
		d.pushBack(5);
		
		d.remove(3);
		assertEquals(5, d.size());
		var c = 0;
		var data = [0, 1, 2, 4, 5];
		for (x in d)
		{
			c++;
			assertEquals(x, data.shift());
		}
		assertEquals(5, c);
	}
	
	function testRemoveCase3()
	{
		//work to head
		var d = createDequeInt();
		for (i in 0...20) d.pushBack(i);
		
		d.remove(16);
		
		var c = 0;
		var data = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 17, 18, 19];
		for (x in d)
		{
			c++;
			assertEquals(x, data.shift());
		}
		assertEquals(19, c);
		
		//work to tail
		var d = createDequeInt();
		for (i in 0...20) d.pushBack(i);
		
		d.remove(8);
		
		var c = 0;
		var data = [0, 1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19];
		for (x in d)
		{
			c++;
			assertEquals(x, data.shift());
		}
		assertEquals(19, c);
	}
	
	function testPushPopFront1()
	{
		var d = createDequeInt();
		d.pushFront(1);
		
		assertEquals(1, d.front());
		assertEquals(1, d.back());
		
		assertEquals(1, d.popFront());
		
		assertTrue(d.isEmpty());
		assertEquals(0, d.size());
	}
	
	function testPushPopFront2()
	{
		var d = createDequeInt();
		d.pushBack(1);
		
		assertEquals(1, d.front());
		assertEquals(1, d.back());
	}
	
	function testInterface()
	{
		//pushFront, popFront
		var d = createDequeInt();
		for (i in 0...4)
		{
			d.pushFront(i);
			assertEquals(i, d.front());
			assertEquals(0, d.back());
		}
		
		assertEquals(4, d.size());
		
		for (i in 4...8)
		{
			d.pushFront(i);
			assertEquals(i, d.front());
			assertEquals(0, d.back());
		}
		
		assertEquals(8, d.size());
		
		var j = 7;
		for (i in 0...8)
		{
			assertEquals(j--, d.popFront());
			
			if (j > 0)
				assertEquals(j, d.front());
		}
		
		assertEquals(0, d.size());
		
		//pushFront, popBack
		var d = createDequeInt();
		for (i in 0...8)
		{
			d.pushFront(i);
			assertEquals(i, d.front());
			assertEquals(0, d.back());
		}
		
		var j = 7;
		for (i in 0...8)
		{
			assertEquals(i, d.popBack());
			
			if (i < 7)
			{
				assertEquals(7, d.front());
				assertEquals(i + 1, d.back());
			}
		}
		
		assertEquals(0, d.size());
		
		//pushBack, popFront
		var d = createDequeInt();
		for (i in 0...8)
		{
			d.pushBack(i);
			assertEquals(0, d.front());
			assertEquals(i, d.back());
		}
		
		for (i in 0...8)
		{
			assertEquals(i, d.popFront());
			
			if (i < 7)
			{
				assertEquals(i + 1, d.front());
				assertEquals(7, d.back());
			}
		}
		
		//pushBack, popBack
		var d = createDequeInt();
		for (i in 0...8)
		{
			d.pushBack(i);
			assertEquals(0, d.front());
			assertEquals(i, d.back());
		}
		
		var j = 7;
		for (i in 0...8)
		{
			assertEquals(j--, d.popBack());
			
			if (i < 7)
			{
				assertEquals(0, d.front());
				assertEquals(j, d.back());
			}
		}
	}
	
	function testFrontFill()
	{
		var d = createDequeInt(8);
		
		for (i in 0...5)
		{
			d.pushFront(i);
			assertEquals(i, d.front());
			assertEquals(0, d.back());
		}
		for (i in 0...5)
		{
			var x = d.popFront();
			assertEquals(5 - 1 - i, x);
		}
	}
	
	function testBackFill()
	{
		var d = createDequeInt(8);
		
		for (i in 0...5)
		{
			d.pushBack(i);
			assertEquals(i, d.back());
			assertEquals(0, d.front());
		}
		
		for (i in 0...5)
		{
			assertEquals(5 - i - 1, d.back());
			var x = d.popBack();
			assertEquals(5 - i - 1, x);
		}
	}
	
	function testFrontBack()
	{
		var d = new LinkedDeque<Int>(10);
		
		d.pushFront(0);
		assertEquals(0, d.popBack());
		d.pushFront(1);
	}
	
	function testClone1()
	{
		var d = new LinkedDeque<Int>(10);
		for (i in 0...10)
		{
			d.pushFront(i);
		}
		
		var clone:LinkedDeque<Int> = cast d.clone(true);
		
		assertEquals(d.size(), clone.size());
		
		untyped 
		{
			var node = clone._head;
			var i = 9;
			while (node != null)
			{
				assertEquals(node.val, i--);
				node = node.next;
			}
			
			assertEquals(9, clone._head.val);
			assertEquals(0, clone._tail.val);
		}
		
		var d = new LinkedDeque<Int>();
		d.pushFront(0);
		var clone:LinkedDeque<Int> = cast d.clone(true);
		assertEquals(d.size(), clone.size());
		untyped 
		{
			assertEquals(clone._head.val, 0);
			assertEquals(clone._tail.val, 0);
		}
		
		var d = new LinkedDeque<Int>();
		d.pushFront(0);
		d.pushFront(1);
		var clone:LinkedDeque<Int> = cast d.clone(true);
		assertEquals(d.size(), clone.size());
		untyped 
		{
			assertEquals(clone._head.val, 1);
			assertEquals(clone._tail.val, 0);
		}
	}
	
	function testClone2()
	{
		var d = new LinkedDeque<E>(10);
		for (i in 0...10)
		{
			d.pushFront(new E(i));
		}
		
		var clone:LinkedDeque<E> = cast d.clone(false);
		assertEquals(d.size(), clone.size());
		
		untyped 
		{
			var node = clone._head;
			var i = 9;
			while (node != null)
			{
				assertEquals(node.val.id, i--);
				node = node.next;
			}
			
			assertEquals(9, clone._head.val.id);
			assertEquals(0, clone._tail.val.id);
		}
		
		var d = new LinkedDeque<E>();
		d.pushFront(new E(0));
		var clone:LinkedDeque<E> = cast d.clone(false);
		assertEquals(d.size(), clone.size());
		untyped 
		{
			assertEquals(clone._head.val.id, 0);
			assertEquals(clone._tail.val.id, 0);
		}
		
		var d = new LinkedDeque<E>();
		d.pushFront(new E(0));
		d.pushFront(new E(1));
		var clone:LinkedDeque<E> = cast d.clone(false);
		assertEquals(d.size(), clone.size());
		untyped 
		{
			assertEquals(clone._head.val.id, 1);
			assertEquals(clone._tail.val.id, 0);
		}
	}
	
	function testClone3()
	{
		var d = new LinkedDeque<E>(10);
		for (i in 0...10)
		{
			d.pushFront(new E(i));
		}
		
		var clone:LinkedDeque<E> = cast d.clone(false, function(x:E):E { return new E(x.id); } );
		assertEquals(d.size(), clone.size());
		
		untyped 
		{
			var node = clone._head;
			var i = 9;
			while (node != null)
			{
				assertEquals(node.val.id, i--);
				node = node.next;
			}
			
			assertEquals(9, clone._head.val.id);
			assertEquals(0, clone._tail.val.id);
		}
		
		var d = new LinkedDeque<E>();
		d.pushFront(new E(0));
		var clone:LinkedDeque<E> = cast d.clone(false, function(x:E):E { return new E(x.id); } );
		assertEquals(d.size(), clone.size());
		untyped 
		{
			assertEquals(clone._head.val.id, 0);
			assertEquals(clone._tail.val.id, 0);
		}
		
		var d = new LinkedDeque<E>();
		d.pushFront(new E(0));
		d.pushFront(new E(1));
		var clone:LinkedDeque<E> = cast d.clone(false, function(x:E):E { return new E(x.id); } );
		assertEquals(d.size(), clone.size());
		untyped 
		{
			assertEquals(clone._head.val.id, 1);
			assertEquals(clone._tail.val.id, 0);
		}
	}
	
	function testFree()
	{
		var d = new LinkedDeque<Int>(10);
		for (i in 0...20)
			d.pushFront(i);
		
		for (i in 0...20)
			d.popFront();
		
		for (i in 0...20)
			d.pushFront(i);
			
		d.free();
		
		assertTrue(true);
	}
	
	function testContains2()
	{
		var d = new LinkedDeque<Int>(10);
		d.pushFront(0);
		d.pushFront(1);
		d.pushFront(2);
		assertTrue(d.contains(0));
		assertTrue(d.contains(1));
		assertTrue(d.contains(2));
		assertFalse(d.contains(3));
	}
	
	function testRemove()
	{
		var d = new LinkedDeque<Int>(10);
		d.pushFront(0);
		d.pushFront(1);
		d.pushFront(2);
		
		d.remove(1);
		assertEquals(2, d.size());
		
		d.remove(2);
		assertEquals(1, d.size());
		
		d.remove(0);
		assertEquals(0, d.size());
		
		var d = new LinkedDeque<Int>(10);
		d.pushFront(0);
		d.pushFront(0);
		d.pushFront(0);
		
		assertEquals(3, d.size());
		
		d.remove(0);
		assertTrue(d.isEmpty());
	}
	
	function testClear2()
	{
		var d = new LinkedDeque<Int>(10);
		for (i in 0...20)
			d.pushFront(i);
		for (i in 0...20)
			d.popFront();
		for (i in 0...5)
			d.pushFront(i);
		
		d.clear(true);
		assertTrue(d.isEmpty());
	}
	
	function testFrontPool()
	{
		var d = new LinkedDeque<Int>(10);
		d.pushFront(0);
		d.pushFront(1);
		d.pushFront(2);
		
		assertEquals(2, d.popFront());
		assertEquals(1, d.popFront());
		assertEquals(0, d.popFront());
		
		d.pushFront(0);
		d.pushFront(1);
		d.pushFront(2);
		
		assertEquals(2, d.popFront());
		assertEquals(1, d.popFront());
		assertEquals(0, d.popFront());
		
		var d = new LinkedDeque<Int>(10);
		for (i in 0...20)
			d.pushFront(i);
		
		for (i in 0...20)
			d.popFront();
		
		for (i in 0...20)
			d.pushFront(i);
	}
	
	function testFront()
	{
		var d = new LinkedDeque<Int>();
		d.pushFront(0);
		d.pushFront(1);
		d.pushFront(2);
		
		assertEquals(2, d.front());
		
		assertEquals(3, d.size());
		
		assertEquals(2, d.popFront());
		assertEquals(1, d.popFront());
		assertEquals(0, d.popFront());
		assertEquals(0, d.size());
		
		d.pushFront(0);
		assertEquals(0, d.front());
		d.pushFront(1);
		assertEquals(1, d.front());
		d.pushFront(2);
		assertEquals(2, d.front());
		
		assertEquals(3, d.size());
		
		assertEquals(2, d.popFront());
		assertEquals(1, d.popFront());
		assertEquals(0, d.popFront());
		assertEquals(0, d.size());
		
		d.pushFront(0);
		assertEquals(1, d.size());
		assertEquals(0, d.popFront());
		assertEquals(0, d.size());
		
		d.pushFront(0);
		assertEquals(1, d.size());
		assertEquals(0, d.popFront());
		assertEquals(0, d.size());
	}
	
	function testBack()
	{
		var d = new LinkedDeque<Int>();
		d.pushBack(0);
		d.pushBack(1);
		d.pushBack(2);
		
		assertEquals(2, d.back());
		
		assertEquals(3, d.size());
		
		assertEquals(2, d.popBack());
		assertEquals(1, d.popBack());
		assertEquals(0, d.popBack());
		assertEquals(0, d.size());
		
		d.pushBack(0);
		assertEquals(0, d.back());
		d.pushBack(1);
		assertEquals(1, d.back());
		d.pushBack(2);
		assertEquals(2, d.back());
		
		assertEquals(3, d.size());
		
		assertEquals(2, d.popBack());
		assertEquals(1, d.popBack());
		assertEquals(0, d.popBack());
		assertEquals(0, d.size());
		
		d.pushBack(0);
		assertEquals(1, d.size());
		assertEquals(0, d.popBack());
		assertEquals(0, d.size());
		
		d.pushBack(0);
		assertEquals(1, d.size());
		assertEquals(0, d.popBack());
		assertEquals(0, d.size());
	}
}

private class E implements Cloneable<E>
{
	public var id:Int;
	
	public function new(id:Int)
	{
		this.id = id;
	}
	
	public function clone():E
	{
		return new E(id);
	}
}