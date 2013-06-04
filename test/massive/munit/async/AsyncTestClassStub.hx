package massive.munit.async;

import massive.munit.async.AsyncFactory;
import massive.munit.util.Timer;

/**
 * Collection of use cases for async test assertions used by TestRunnerTest
 * to validate that syncronous assertions/exceptions are handled correctly.
 */

class AsyncTestClassStub
{
	static public var handlerCount:Int = 0;
	public function new() 
	{}
	
	@BeforeClass
	public function beforeClass():Void
	{
		handlerCount = 0;
	}
	
	@AfterClass
	public function afterClass():Void
	{
	}
	
	@Before
	public function before():Void
	{
	}
	
	@After
	public function after():Void
	{
	}

	@AsyncTest
	public function shouldAssertAsync():Void
	{
		var handler:Dynamic = Async.asyncHandler(this, asyncHandler, 100);
		Timer.delay(handler, 1);
	}

	@AsyncTest
	public function shouldAsyncTimeout():Void
	{
		var handler:Dynamic = Async.asyncHandler(this, asyncHandler, 100);
		//Timer.delay(handler, 500); //not necessary, however is bug where this handler called first on flash targets
	}

	@AsyncTest
	public function shouldAllowSyncAssertInsideAsyncTest():Void
	{
		var handler:Dynamic = Async.asyncHandler(this, asyncHandler, 100);
		Assert.isTrue(true);
		Timer.delay(handler, 1);
	}

	@AsyncTest
	public function shouldCancelAsyncIfExceptionThrown():Void
	{
		var handler:Dynamic = Async.asyncHandler(this, asyncHandler, 100);
		Timer.delay(handler, 1);
		throw "exception in async test";
	}

	@AsyncTest
	public function shouldCancelAsyncIfSyncAssertFailsAfterHandlerCreated():Void
	{
		var handler:Dynamic = Async.asyncHandler(this, asyncHandler, 100);
		Assert.fail("failed assert in async test");
		Timer.delay(handler, 1);
	}

	@AsyncTest
	public function shouldCancelAsyncIfSyncAssertFailsAfterTimerCreated():Void
	{
		var handler:Dynamic = Async.asyncHandler(this, asyncHandler, 100);
		Timer.delay(handler, 1);
		Assert.fail("failed assert in async test");
	}

	@AsyncTest
	public function shouldCancelAsyncIfSyncAssertFailsBeforeHandlerCreated():Void
	{
		Assert.fail("failed assert in async test");
		var handler:Dynamic = Async.asyncHandler(this, asyncHandler, 100);
		Timer.delay(handler, 1);
		
	}


	//------------------
	private function asyncHandler():Void
	{
		handlerCount ++;
		Assert.isTrue(true);
	}
}

/**
 * Secondary class used to verify that no wayward async assertions trigger
 * after the main AsyncTestClassStub tests (or possibly after all other tests have finished).
 */
class AsyncTestClassStub2
{
	public function new()
	{
		
	}
	// @Test
	// public function test()
	// {
	// 	Assert.isTrue(true);
	// }

	@AsyncTest
	public function shouldAssertAsync():Void
	{
		var handler:Dynamic = Async.asyncHandler(this, asyncHandler, 5000);
		Timer.delay(handler, 10);
	}

	private function asyncHandler():Void
	{
		Assert.isTrue(AsyncTestClassStub.handlerCount == 2);
	}
}
