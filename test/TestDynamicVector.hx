﻿import de.polygonal.ds.ArrayConvert;
import de.polygonal.ds.Compare;
import de.polygonal.ds.DynamicVector;
import de.polygonal.ds.ListSet;

import de.polygonal.ds.tools.NativeArray;

@:access(de.polygonal.ds.DynamicVector)
class TestDynamicVector extends AbstractTest
{
	function testBasic()
	{
		var dv = new DynamicVector<Int>();
		
		for (i in 0...20) dv.set(i, i);
		
		for (i in 0...20) assertEquals(i, dv.get(i));
		assertEquals(20, dv.size());
		assertTrue(dv.capacity >= dv.size());
		
		var c = dv.mData;
		for (i in 0...NativeArray.size(c))
		{
			if (i < 20)
				assertEquals(i, c[i]);
			else
				assertEquals(0, 0);
		}
	}
	
	function testReserve()
	{
		var dv = new DynamicVector<Int>();
		for (i in 0...5) dv.set(i, 5 - i);
		dv.reserve(100);
		
		assertEquals(100, dv.capacity);
		assertEquals(5, dv.size());
		
		for (i in 0...95) dv.pushBack(i);
		for (i in 0...5) assertEquals(5 - i, dv.get(i));
		for (i in 0...95) assertEquals(i, dv.get(5 + i));
	}
	
	function testAlloc()
	{
		var dv = new DynamicVector<Int>();
		dv.alloc(5, 10);
		assertEquals(5, dv.size());
		for (i in 0...5) assertEquals(10, dv.get(i));
		
		var dv = new DynamicVector<Int>();
		dv.alloc(20, 10);
		assertEquals(20, dv.size());
		for (i in 0...20) assertEquals(10, dv.get(i));
		
		var dv = new DynamicVector<Int>();
		dv.alloc(20, 0);
		dv.iter(function(e, i) return i);
		for (i in 0...20) assertEquals(i, dv.get(i));
	}
	
	function testInit()
	{
		var dv = new DynamicVector<Int>();
		dv.alloc(5, 0);
		assertEquals(5, dv.size());
		dv.init(0, 5, 10);
		for (i in 0...5) assertEquals(10, dv.get(i));
		
		var dv = new DynamicVector<Int>();
		dv.alloc(5, 0);
		assertEquals(5, dv.size());
		
		dv.init(1, 5 - 1, 10);
		assertEquals(0, dv.get(0));
		for (i in 1...5) assertEquals(10, dv.get(i));
	}
	
	function testIter()
	{
		var dv = new DynamicVector<Int>();
		dv.iter(function(e, i) return i);
		assertEquals(0, dv.size());
		
		var dv = new DynamicVector<Int>();
		dv.alloc(20, 0);
		dv.iter(function(e, i) return i);
		assertEquals(20, dv.size());
		for (i in 0...20) assertEquals(i, dv.get(i));
	}
	
	function testPack()
	{
		var dv = new DynamicVector<Int>().alloc(20, 0);
		dv.pack();
		assertEquals(dv.size(), 20);
		assertEquals(20, dv.capacity);
		assertEquals(5, dv.mShrinkSize);
		
		for (i in 0...10) dv.pushBack(i);
		assertEquals(dv.size(), 30);
	}
	
	function testSwap()
	{
		var dv = new DynamicVector<Int>();
		dv.pushBack(2);
		dv.pushBack(3);
		assertEquals(2, dv.get(0));
		assertEquals(3, dv.get(1));
		dv.swap(0, 1);
		assertEquals(3, dv.get(0));
		assertEquals(2, dv.get(1));
	}
	
	function testCopy()
	{
		var dv = new DynamicVector<Int>();
		dv.pushBack(2);
		dv.pushBack(3);
		dv.copy(0, 1);
		assertEquals(2, dv.front());
		assertEquals(2, dv.back());
	}
	
	function testFront()
	{
		var dv = new DynamicVector<Int>();
		
		#if debug
		var fail = false;
		try
		{
			dv.front();
		}
		catch (unknown:Dynamic)
		{
			fail = true;
		}
		assertTrue(fail);
		#end
		
		dv.pushBack(0);
		assertEquals(0, dv.front());
		assertEquals(1, dv.size());
		
		dv.pushBack(1);
		assertEquals(0, dv.front());
		
		dv.insertAt(0, 1);
		assertEquals(1, dv.front());
	}
	
	function testBack()
	{
		var dv = new DynamicVector<Int>();
		
		#if debug
		var fail = false;
		try
		{
			dv.back();
		}
		catch (unknown:Dynamic)
		{
			fail = true;
		}
		assertTrue(fail);
		#end
		
		dv.pushBack(0);
		assertEquals(0, dv.back());
		assertEquals(1, dv.size());
		
		dv.pushBack(1);
		assertEquals(1, dv.back());
		
		//dv.insertAt(0, 1);
		//assertEquals(1, dv.front());
	}
	
	function testPopFront()
	{
		var dv = new DynamicVector<Int>();
		dv.alloc(5, 0);
		dv.iter(function(e, i) return i);
		var x = dv.popFront();
		assertEquals(0, x);
		
		assertEquals(4, dv.size());
		for (i in 0...4) assertEquals(i + 1, dv.get(i));
		
		var dv = new DynamicVector<Int>();
		dv.set(0, 1);
		var x = dv.popFront();
		assertEquals(1, x);
		assertEquals(0, dv.size());
	}
	
	function testPushFront()
	{
		var dv = new DynamicVector<Int>();
		dv.alloc(5, 0);
		dv.iter(function(e, i) return i);
		dv.pushFront(10);
		assertEquals(6, dv.size());
		assertEquals(10, dv.get(0));
		for (i in 0...5) assertEquals(i, dv.get(i + 1));
		
		var dv = new DynamicVector<Int>();
		dv.pushFront(10);
		assertEquals(1, dv.size());
		assertEquals(10, dv.get(0));
	}
	
	function testPushBack()
	{
		var l = new DynamicVector<Int>();
		l.pushBack(1);
		assertEquals(1, l.back());
		assertEquals(1, l.size());
		l.pushBack(2);
		assertEquals(2, l.back());
		assertEquals(2, l.size());
		l.pushBack(3);
		assertEquals(3, l.back());
		assertEquals(3, l.size());
		assertEquals(3, l.popBack());
		assertEquals(2, l.back());
		assertEquals(2, l.popBack());
		assertEquals(1, l.back());
		assertEquals(1, l.popBack());
		assertEquals(0, l.size());
	}
	
	function testPopBack()
	{
		var l = new DynamicVector<Int>();
		var x = 0;
		l.pushBack(x);
		assertEquals(1, l.size());
		assertEquals(x, l.front());
		assertEquals(x, l.popBack());
		assertEquals(0, l.size());
		x = 1;
		l.pushBack(x);
		assertEquals(1, l.size());
		assertEquals(x, l.front());
		assertEquals(x, l.popBack());
		assertEquals(0, l.size());
	}
	
	function testSwapPop()
	{
		var dv = new DynamicVector<Int>();
		dv.alloc(5, 0);
		dv.iter(function(e, i) return i);
		var x = dv.swapPop(0);
		assertEquals(0, x);
		assertEquals(4, dv.size());
		assertEquals(1, dv.get(1));
		assertEquals(2, dv.get(2));
		assertEquals(3, dv.get(3));
		
		var da = new DynamicVector<Int>();
		da.pushBack(0);
		da.swapPop(0);
		assertEquals(0, da.size());
		
		var da = new DynamicVector<Int>();
		da.pushBack(0);
		da.pushBack(1);
		da.swapPop(0);
		assertEquals(1, da.size());
		assertEquals(da.get(0), 1);
		
		var da = new DynamicVector<Int>();
		da.pushBack(0);
		da.pushBack(1);
		da.pushBack(2);
		da.swapPop(1);
		
		assertEquals(2, da.size());
		assertEquals(da.get(0), 0);
		assertEquals(da.get(1), 2);
	}
	
	function testTrim()
	{
		var dv = new DynamicVector<Int>();
		dv.alloc(20, 0);
		dv.iter(function(e, i) return i);
		dv.trim(10);
		assertEquals(10, dv.size());
		for (i in 0...10) assertEquals(i, dv.get(i));
	}
	
	function testInsertAt()
	{
		var dv = new DynamicVector<Int>();
		dv.insertAt(0, 1);
		assertEquals(1, dv.size());
		assertEquals(1, dv.get(0));
		
		var dv = new DynamicVector<Int>();
		for (i in 0...3) dv.pushBack(i);
		assertEquals(3, dv.size());
		
		dv.insertAt(0, 5);
		assertEquals(4, dv.size());
		assertEquals(5, dv.get(0));
		assertEquals(0, dv.get(1));
		assertEquals(1, dv.get(2));
		assertEquals(2, dv.get(3));
		
		var dv = new DynamicVector<Int>();
		for (i in 0...3) dv.pushBack(i);
		assertEquals(3, dv.size());
		
		dv.insertAt(1, 5);
		assertEquals(4, dv.size());
		
		assertEquals(0, dv.get(0));
		assertEquals(5, dv.get(1));
		assertEquals(1, dv.get(2));
		assertEquals(2, dv.get(3));
		
		var dv = new DynamicVector<Int>();
		for (i in 0...3) dv.pushBack(i);
		assertEquals(3, dv.size());
		
		dv.insertAt(2, 5);
		assertEquals(4, dv.size());
		
		assertEquals(0, dv.get(0));
		assertEquals(1, dv.get(1));
		assertEquals(5, dv.get(2));
		assertEquals(2, dv.get(3));
		
		var dv = new DynamicVector<Int>();
		for (i in 0...3) dv.pushBack(i);
		assertEquals(3, dv.size());
		
		dv.insertAt(3, 5);
		assertEquals(4, dv.size());
		
		assertEquals(0, dv.get(0));
		assertEquals(1, dv.get(1));
		assertEquals(2, dv.get(2));
		assertEquals(5, dv.get(3));
		
		var dv = new DynamicVector<Int>();
		dv.insertAt(0, 0);
		dv.insertAt(1, 1);
		
		assertEquals(0, dv.get(0));
		assertEquals(1, dv.get(1));
		
		var s = 20;
		for (i in 0...s)
		{
			var dv = new DynamicVector<Int>(s);
			for (i in 0...s) dv.set(i, i);
			dv.insertAt(i, 100);
			for (j in 0...i) assertEquals(j, dv.get(j));
			assertEquals(100, dv.get(i));
			var v = i;
			for (j in i + 1...s + 1) assertEquals(v++, dv.get(j));
		}
	}
	
	function testRemoveAt()
	{
		var dv = new DynamicVector<Int>();
		for (i in 0...3) dv.pushBack(i);
		
		for (i in 0...3)
		{
			assertEquals(i, dv.removeAt(0));
			assertEquals(3 - i - 1, dv.size());
		}
		assertEquals(0, dv.size());
		
		for (i in 0...3) dv.pushBack(i);
		
		var size = 3;
		while (dv.size() > 0)
		{
			dv.removeAt(dv.size() - 1);
			size--;
			assertEquals(size, dv.size());
		}
		
		assertEquals(0, dv.size());
	}
	
	function testJoin()
	{
		var dv = new DynamicVector<Int>();
		assertEquals("", dv.join(","));
		dv.pushBack(0);
		assertEquals("0", dv.join(","));
		dv.pushBack(1);
		assertEquals("0,1", dv.join(","));
		dv.pushBack(2);
		assertEquals("0,1,2", dv.join(","));
		dv.pushBack(3);
		assertEquals("0,1,2,3", dv.join(","));
	}
	
	function testReverse()
	{
		var dv = new DynamicVector<Int>();
		dv.pushBack(0);
		dv.pushBack(1);
		dv.reverse();
		
		assertEquals(1, dv.get(0));
		assertEquals(0, dv.get(1));
		
		var dv = new DynamicVector<Int>();
		dv.pushBack(0);
		dv.pushBack(1);
		dv.pushBack(2);
		dv.reverse();
		assertEquals(2, dv.get(0));
		assertEquals(1, dv.get(1));
		assertEquals(0, dv.get(2));
		
		var dv = new DynamicVector<Int>();
		dv.pushBack(0);
		dv.pushBack(1);
		dv.pushBack(2);
		dv.pushBack(3);
		dv.reverse();
		assertEquals(3, dv.get(0));
		assertEquals(2, dv.get(1));
		assertEquals(1, dv.get(2));
		assertEquals(0, dv.get(3));
		
		var dv = new DynamicVector<Int>();
		dv.pushBack(0);
		dv.pushBack(1);
		dv.pushBack(2);
		dv.pushBack(3);
		dv.pushBack(4);
		
		dv.reverse();
		
		assertEquals(4, dv.get(0));
		assertEquals(3, dv.get(1));
		assertEquals(2, dv.get(2));
		assertEquals(1, dv.get(3));
		assertEquals(0, dv.get(4));
		
		var dv = new DynamicVector<Int>();
		for (i in 0...27) dv.pushBack(i);
		dv.reverse();
		for (i in 0...27) assertEquals(26 - i, dv.get(i));
		
		var dv = new DynamicVector<Int>();
		for (i in 0...4) dv.set(i, i);
		dv.reverse();
		for (i in 0...4) assertEquals(3 - i, dv.get(i));
		
		var da = new DynamicVector<Int>();
		
		da.pushBack(8);
		da.pushBack(7);
		da.pushBack(4);
		da.pushBack(2);
		da.pushBack(4);
		
		da.reverse();
		da.clear();
		
		da.pushBack(8);
		da.pushBack(10);
		da.pushBack(11);
		da.pushBack(3);
		
		da.reverse();
		
		assertEquals(3 , da.get(0));
		assertEquals(11, da.get(1));
		assertEquals(10, da.get(2));
		assertEquals(8 , da.get(3));
		
		var dv = new DynamicVector<Int>(10);
		for (i in 0...10) dv.pushBack(i);
		dv.reverse();
		for (i in 0...10) assertEquals(10 - i - 1, dv.get(i));
		
		var dv = new DynamicVector<Int>(10);
		for (i in 0...10) dv.pushBack(i);
		dv.reverse(0, 5);
		for (i in 0...5) assertEquals(5 - i - 1, dv.get(i));
		for (i in 5...10) assertEquals(i, dv.get(i));
		
		var dv = new DynamicVector<Int>(10);
		for (i in 0...10) dv.pushBack(i);
		dv.reverse(0, 1);
		assertEquals(0, dv.get(0));
		assertEquals(1, dv.get(1));
		
		var dv = new DynamicVector<Int>(10);
		for (i in 0...10) dv.pushBack(i);
		dv.reverse(0, 2);
		assertEquals(1, dv.get(0));
		assertEquals(0, dv.get(1));
	}
	
	function testIndexOf()
	{
		var l = new DynamicVector<Int>();
		assertEquals(-1, l.indexOf(0));
		for (i in 0...3) l.pushBack(i);
		assertEquals(0, l.indexOf(0));
		assertEquals(1, l.indexOf(1));
		assertEquals(2, l.indexOf(2));
		assertEquals(-1, l.indexOf(4));
		
		var l = new DynamicVector<Int>();
		for (i in 0...3) l.pushBack(i);
		l.indexOf(0, 2);
		
		var l = new DynamicVector<Int>();
		for (i in 0...10) l.pushBack(i);
		
		#if !neko
		assertEquals(10, ~l.indexOf(10, 0, true, function(a, b) { return a - b;}));
		#end
		assertEquals(-1, l.indexOf(-100, 0, true, function(a, b) { return a - b;}));
		
		for (i in 0...10) assertEquals(i, l.indexOf(i, 0, true, function(a, b) { return a - b;}));
		for (i in 0...10) assertEquals(i, l.indexOf(i, i, true, function(a, b) { return a - b;}));
		for (i in 0...9)
			assertTrue(l.indexOf(i, i+1, true, function(a, b) { return a - b;}) < 0);
		
		var l = new DynamicVector<E>();
		
		for (i in 0...10) l.pushBack(new E(i));
		
		for (i in 0...10) assertEquals(i, l.indexOf(l.get(i), 0, true));
		for (i in 0...10) assertEquals(i, l.indexOf(l.get(i), i, true));
		for (i in 0...9)
			assertTrue(l.indexOf(l.get(i), i+1, true) < 0);
	}
	
	function testLastIndexOf()
	{
		var l = new DynamicVector<Int>();
		assertEquals(-1, l.lastIndexOf(0));
		
		for (i in 0...3) l.pushBack(i);
		assertEquals(0, l.lastIndexOf(0));
		assertEquals(1, l.lastIndexOf(1));
		assertEquals(2, l.lastIndexOf(2));
		assertEquals(-1, l.lastIndexOf(4));
		
		var l = new DynamicVector<Int>();
		l.pushBack(0);
		l.pushBack(1);
		l.pushBack(2);
		l.pushBack(3);
		l.pushBack(4);
		l.pushBack(5);
		
		assertEquals(5, l.lastIndexOf(5, -1));
		assertEquals(5, l.lastIndexOf(5));
		
		assertEquals(-1, l.lastIndexOf(5, -2));
		assertEquals(-1, l.lastIndexOf(5, -3));
		assertEquals(-1, l.lastIndexOf(5, 1));
	}
	
	function testMemMove()
	{
		var l = new DynamicVector<Int>();
		for (i in 0...20) l.pushBack(i);
		
		l.memmove(0, 10, 10);
		
		for (i in 0...10)
			assertEquals(i + 10, l.get(i));
		for (i in 10...20)
			assertEquals(i, l.get(i));
		
		var l = new DynamicVector<Int>();
		for (i in 0...20) l.pushBack(i);
		
		l.memmove(10, 0, 10);
		
		for (i in 0...10)
			assertEquals(i, l.get(i));
		for (i in 10...20)
			assertEquals(i-10, l.get(i));
		
		var l = new DynamicVector<Int>();
		for (i in 0...20) l.pushBack(i);
		
		l.memmove(5, 0, 10);
		
		for (i in 0...5) assertEquals(i, l.get(i));
		for (i in 5...15) assertEquals(i - 5, l.get(i));
		for (i in 15...20) assertEquals(i, l.get(i));
	}
	
	function testConcat()
	{
		var a = new DynamicVector<Int>();
		a.pushBack(0);
		a.pushBack(1);
		var b = new DynamicVector<Int>();
		b.pushBack(2);
		b.pushBack(3);
		var c = a.concat(b, true);
		assertEquals(4, c.size());
		for (i in 0...4) assertEquals(i, c.get(i));
		a.concat(b);
		assertEquals(4, a.size());
		for (i in 0...4) assertEquals(i, a.get(i));
		
		var a = new DynamicVector<Int>();
		a.pushBack(0);
		a.pushBack(1);
		var b = new DynamicVector<Int>();
		b.pushBack(2);
		b.pushBack(3);
		a.concat(b);
		assertEquals(4, a.size());
		assertEquals(2, b.size());
		for (i in 0...4) assertEquals(i, a.get(i));
	}
	
	function testConvert()
	{
		var dv = new DynamicVector([0, 1, 2, 3]);
		
		assertEquals(dv.size(), 4);
		for (x in 0...4) assertEquals(x, dv.get(x));
		
		var dv = new DynamicVector<Int>();
		var itr = dv.iterator();
		for (i in dv) {}
		
		var dv = new DynamicVector([0, 1, 2, 3]);
		var itr = dv.iterator();
		for (i in dv) {}
	}
	
	function testSortRange()
	{
		var d = new DynamicVector<Int>();
		d.pushBack(0);
		d.pushBack(1);
		d.pushBack(2);
		d.pushBack(3);
		d.pushBack(30);
		d.pushBack(20);
		d.pushBack(30);
		d.sort(Compare.compareNumberFall, true, 0, 4);
		
		var sorted = [3, 2, 1, 0, 30, 20, 30];
		for (i in 0...d.size()) assertEquals(sorted[i], d.get(i));
		assertEquals(3, d.get(0));
		assertEquals(2, d.get(1));
		assertEquals(1, d.get(2));
		assertEquals(0, d.get(3));
		assertEquals(30, d.get(4));
		assertEquals(20, d.get(5));
		assertEquals(30, d.get(6));
		
		var d = new DynamicVector([9, 8, 1, 2, 3, 8, 9]);
		d.sort(Compare.compareNumberFall, true, 2, 3);
		
		var sorted = new DynamicVector([9, 8, 3, 2, 1, 8, 9]);
		for (i in 0...d.size()) assertEquals(sorted.get(i), d.get(i));
		
		var d = new DynamicVector([9, 8, 1, 2, 3, 8, 9]);
		d.sort(Compare.compareNumberFall, false, 2, 3);
		var sorted = [9, 8, 3, 2, 1, 8, 9];
		for (i in 0...d.size()) assertEquals(sorted[i], d.get(i));
		
		var d = new DynamicVector([1, 2, 3]);
		d.sort(Compare.compareNumberFall, true, 2, -1);
		var sorted = [1, 2, 3];
		for (i in 0...d.size()) assertEquals(sorted[i], d.get(i));
		
		var d = new DynamicVector([1, 2, 3]);
		d.sort(Compare.compareNumberFall, false, 1, 2);
		var sorted = [1, 3, 2];
		for (i in 0...d.size()) assertEquals(sorted[i], d.get(i));
		
		var d = new DynamicVector([1, 2, 3]);
		d.sort(Compare.compareNumberFall, true, 1, 2);
		var sorted = [1, 3, 2];
		for (i in 0...d.size()) assertEquals(sorted[i], d.get(i));
	}
	
	function testSort()
	{
		//1
		var v = new DynamicVector([4]);
		v.sort(Compare.compareNumberRise);
		assertEquals(4, v.front());
		
		var v = new DynamicVector([4]);
		v.sort(Compare.compareNumberRise, true);
		assertEquals(4, v.front());
		
		var v = new DynamicVector([new EComparable(4)]);
		v.sort(null);
		assertEquals(4, v.front().val);
		
		var v = new DynamicVector([new EComparable(4)]);
		v.sort(null, true);
		assertEquals(4, v.front().val);
		
		//2
		var v = new DynamicVector([4, 2]);
		v.sort(Compare.compareNumberRise);
		assertEquals(2, v.front());
		assertEquals(4, v.back());
		
		var v = new DynamicVector([4, 2]);
		v.sort(Compare.compareNumberFall);
		assertEquals(4, v.front());
		assertEquals(2, v.back());
		
		var v = new DynamicVector([4, 2]);
		v.sort(Compare.compareNumberRise, true);
		assertEquals(2, v.front());
		assertEquals(4, v.back());
		
		var v = new DynamicVector([4, 2]);
		v.sort(Compare.compareNumberFall, true);
		assertEquals(4, v.front());
		assertEquals(2, v.back());
		
		var v = new DynamicVector([new EComparable(4), new EComparable(2)]);
		v.sort(null);
		assertEquals(2, v.front().val);
		assertEquals(4, v.back().val);
		
		//n
		var v = new DynamicVector([4, 1, 7, 3, 2]);
		v.sort(Compare.compareNumberRise);
		assertEquals(1, v.front());
		
		var j = 0; for (i in v) { assertTrue(i >= j); j = i; }
		
		var v = new DynamicVector([4, 1, 7, 3, 2]);
		v.sort(Compare.compareNumberFall);
		assertEquals(7, v.front());
		var j = 7; for (i in v) { assertTrue(i <= j); j = i; }
		
		var v = new DynamicVector([new EComparable(4), new EComparable(1), new EComparable(7), new EComparable(3), new EComparable(2)]);
		v.sort(null);
		assertEquals(1, v.front().val);
		var j = 0; for (i in v) { assertTrue(i.val >= j); j = i.val; }
	}
	
	function testShuffle()
	{
		var q = new DynamicVector<Int>();
		q.alloc(10, 0).iter(function(e, i) return i);
		
		q.shuffle();
		
		assertEquals(10, q.size());
		
		var set = new Array<Int>();
		
		for (i in 0...10)
		{
			assertFalse(contains(set, q.get(i)));
			set.push(q.get(i));
		}
		
		set.sort(function(a, b) return a - b);
		for (i in 0...10) assertEquals(i, set[i]);
	}
	
	function testIterator()
	{
		var q:DynamicVector<Int> = new DynamicVector<Int>();
		for (i in 0...10) q.pushBack(i);
		
		var c = 0;
		var itr:de.polygonal.ds.ResettableIterator<Int> = cast q.iterator();
		for (val in itr)
			assertEquals(c++, val);
		assertEquals(c, 10);
		
		c = 0;
		itr.reset();
		for (val in itr) assertEquals(c++, val);
		assertEquals(c, 10);
		
		var set = new ListSet<Int>();
		for (val in q) assertTrue(set.set(val));
		
		var itr:de.polygonal.ds.ResettableIterator<Int> = cast q.iterator();
		
		var s:de.polygonal.ds.Set<Int> = cast set.clone(true);
		var c = 0;
		for (val in itr) assertEquals(true, s.remove(val));
		assertTrue(s.isEmpty());
		
		var s:de.polygonal.ds.Set<Int> = cast set.clone(true);
		
		itr.reset();
		for (val in itr) assertEquals(true, s.remove(val));
		assertTrue(s.isEmpty());
		
		q.pushBack(10);
		var s:de.polygonal.ds.Set<Int> = cast set.clone(true);
		s.set(10);
		
		itr.reset();
		for (val in itr) assertEquals(true, s.remove(val));
		assertTrue(s.isEmpty());
	}
	
	function testIteratorRemove()
	{
		for (i in 0...5)
		{
			var da = new DynamicVector<Int>();
			var set = new de.polygonal.ds.ListSet<Int>();
			for (j in 0...5)
			{
				da.pushBack(j);
				if (i != j) set.set(j);
			}
			
			var itr = da.iterator();
			while (itr.hasNext())
			{
				var val = itr.next();
				if (val == i) itr.remove();
			}
			
			while (!da.isEmpty())
				assertTrue(set.remove(da.popBack()));
			assertTrue(set.isEmpty());
		}
		
		var da = new DynamicVector<Int>();
		for (j in 0...5) da.pushBack(j);
		
		var itr = da.iterator();
		while (itr.hasNext())
		{
			itr.next();
			itr.remove();
		}
		assertTrue(da.isEmpty());
	}
	
	function testRemove()
	{
		var a = new DynamicVector([0, 1, 2, 2, 2, 3]);
		
		assertEquals(6, a.size());
		
		var k = a.remove(0);
		assertEquals(true, k);
		assertEquals(5, a.size());
		
		var k = a.remove(2);
		assertEquals(true, k);
		assertEquals(2, a.size());
		
		var k = a.remove(1);
		assertEquals(true, k);
		assertEquals(1, a.size());
		
		var k = a.remove(3);
		assertEquals(true, k);
		
		assertTrue(a.isEmpty());
		
		var a = new DynamicVector([0, 0, 0, 0, 0]);
		var k = a.remove(0);
		assertEquals(true, k);
		assertTrue(a.isEmpty());
	}
	
	function testClone()
	{
		var dv = new DynamicVector<Int>();
		for (i in 0...3) dv.pushBack(i);
		
		var copy:DynamicVector<Int> = cast dv.clone(true);
		
		assertEquals(3, copy.size());
		
		for (i in 0...3) assertEquals(i, copy.get(i));
		
		return;
		
		var dv = new DynamicVector<Int>();
		for (i in 0...3) dv.pushBack(i);
		
		var copy:DynamicVector<Int> = cast dv.clone(true);
		
		assertEquals(3, copy.size());
		
		for (i in 0...3) assertEquals(i, copy.get(i));
	}
}

private class E implements de.polygonal.ds.Comparable<E>
{
	public var x:Int;
	public function new(x:Int)
	{
		this.x = x;
	}
	
	public function compare(other:E):Int
	{
		return x - other.x;
	}
}

private class EComparable implements de.polygonal.ds.Comparable<EComparable>
{
	public var val:Int;
	public function new(val:Int)
	{
		this.val = val;
	}
	
	public function compare(other:EComparable):Int
	{
		return val - other.val;
	}
	
	public function toString():String
	{
		return "{" + val + "}";
	}
}