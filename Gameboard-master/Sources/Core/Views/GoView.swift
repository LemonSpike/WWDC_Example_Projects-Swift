import UIKit

public class GoView: UIView {
    
    public var p: CGFloat = 20
    public var lineColor = UIColor.black
    
    public override func draw(_ rect: CGRect) {
        
        let c = UIGraphicsGetCurrentContext()
        
        c!.setLineCap(.round)
        c!.setLineJoin(.round)
        
        lineColor.set()
        
        let w8 = (rect.width - p * 2) / 8
        let h8 = (rect.height - p * 2) / 8
        
        for row in 0...8 {
            
            for col in 0...8 {
                
                c?.move(to: CGPoint(x: w8 * col + p,y: p))
                c?.addLine(to: CGPoint(x: w8 * col + p,y: rect.height - p))
                
                c?.move(to: CGPoint(x: p,y: h8 * row + p))
                c?.addLine(to: CGPoint(x: rect.width - p,y: h8 * row + p))
                
            }
            
        }
        
        c!.strokePath()
        
    }
    
}
