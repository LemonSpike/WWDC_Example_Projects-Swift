import UIKit

class HintLabel: UILabel {
    
    var highlight: Bool = false { didSet { setNeedsDisplay() } }
    var highlightColor: UIColor = UIColor.red
    
    
    override func drawText(in rect: CGRect) {
        
        guard highlight else { return super.drawText(in: rect) }
        
        let ctx = UIGraphicsGetCurrentContext()
        
        highlightColor.set()
        
        ctx!.setLineJoin(.round)
        ctx!.setLineWidth(1)
        
        ctx!.stroke(rect.insetBy(dx: 3, dy: 3))
        
        super.drawText(in: rect)
        
    }
    
}

