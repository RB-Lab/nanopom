import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
  var statusItem: NSStatusItem!
  var timer: Timer?
  var isBlinking = false
  var icon: NSImage?
  var counter = 0
  var blinkAfter = 45

  func applicationDidFinishLaunching(_ notification: Notification) {
    // print("applicationDidFinishLaunching called")
    // Create the status item in the menu bar
    statusItem = NSStatusBar.system.statusItem(withLength: 35)
    if let button = statusItem?.button {
      icon = NSImage(systemSymbolName: "stopwatch.fill", accessibilityDescription: "Nano Pomodoro")
      button.image = icon
      button.action = #selector(toggleBlinking)
      button.title = "00"
    }

    startTimer()
  }

  func startTimer() {
    // print("startTimer called, blinkAfter: \(blinkAfter) minutes")
    counter = 0
    timer = Timer.scheduledTimer(
      timeInterval: 60, target: self, selector: #selector(timerFired), userInfo: nil,
      repeats: true)
  }

  @objc func timerFired() {
    counter += 1
    if let button = statusItem?.button {
      button.title = "\(String(format: "%02d", counter))"
    }
    if counter >= blinkAfter && !isBlinking {
      startBlinking()
    }
  }

  @objc func startBlinking() {
    // print("startBlinking called")
    isBlinking = true
    blinkIcon()
  }
  func blinkIcon() {
    if isBlinking {
      if let button = statusItem?.button, let icon = icon {
        let newIcon = iconWithAlpha(icon: icon, alpha: icon.isTemplate ? 1.0 : 0.1)
        button.image = newIcon
        icon.isTemplate.toggle()
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        self.blinkIcon()
      }
    } else {
      statusItem.button?.image = icon
    }
  }

  func iconWithAlpha(icon: NSImage, alpha: CGFloat) -> NSImage {
    let newIcon = NSImage(size: icon.size)
    newIcon.lockFocus()
    let rect = NSRect(origin: .zero, size: icon.size)
    icon.draw(in: rect, from: rect, operation: .sourceOver, fraction: alpha)
    newIcon.unlockFocus()
    newIcon.isTemplate = true
    return newIcon
  }

  @objc func toggleBlinking() {
    // print("toggleBlinking called")
    isBlinking = false
    counter = 0
    if let button = statusItem?.button {
      button.image = icon
      button.title = "00"
    }
    timer?.invalidate()
    startTimer()
  }
}

// Start the application
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
