import Cocoa

let app = NSApplication.sharedApplication()

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        test()
    }
    
    func test() {
        assert(1.second == 1.0)
        assert(1.minute == 60.0)
        assert(1.hour == 1.minute * 60)
        assert(1.2.seconds == 1.2)
        assert(1.5.minutes == 90.0)
        assert(1.5.hours == 5400.0)
        assert(1.3.milliseconds == 0.0013)
        assert(0.5.day == 43_200 )
        assert(1.day == 86_400 )
        assert(2.days == 172_800)
        test2()
    }
    
    func test2() {
        var fired = false
        NSTimer.after(0.1.seconds) {
            assert(!fired)
            fired = true
            self.test3()
        }
    }
    
    var timer1: NSTimer!
    
    func test3() {
        var fired = false
        timer1 = NSTimer.every(0.1.seconds) {
            if fired {
                self.test4()
                self.timer1.invalidate()
            } else {
                fired = true
            }
        }
    }
    
    let timer2 = NSTimer.new(after: 0.1.seconds) { fatalError() }
    let timer3 = NSTimer.new(every: 0.1.seconds) { fatalError() }
    
    func test4() {
        let timer = NSTimer.new(after: 0.1.seconds) {
            self.test5()
        }
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
    }
    
    var timer4: NSTimer!
    
    func test5() {
        var fired = false
        timer4 = NSTimer.new(every: 0.1.seconds) {
            if fired {
                self.timer4.invalidate()
                self.test6()
            } else {
                fired = true
            }
        }
        timer4.start()
    }
    
    func test6() {
        let timer = NSTimer.new(after: 0.1.seconds) {
            self.test7()
        }
        
        timer.start(runLoop: NSRunLoop.currentRunLoop(), modes: NSDefaultRunLoopMode, NSEventTrackingRunLoopMode)
    }

    func test7() {
        NSTimer.after(0.1.seconds, test8)
    }
    
    func test8() {
        var fires = 0
        let timer = NSTimer.new(every: 0.1.seconds) { (timer: NSTimer) in
            guard fires <= 1 else { fatalError("should be invalidated") }
            defer { fires += 1 }
            
            if fires == 1 {
                timer.invalidate()
                self.test9()
            }
        }
        timer.start()
    }
    
    func test9() {
        var fires = 0
        NSTimer.every(0.1.seconds) { (timer: NSTimer) in
            guard fires <= 1 else { fatalError("should be invalidated") }
            defer { fires += 1 }
            
            if fires == 1 {
                timer.invalidate()
                self.done()
            }
        }
    }
    
    func done() {
        print("All tests passed")
        app.terminate(self)
    }
}

let delegate = AppDelegate()
app.delegate = delegate
app.run()