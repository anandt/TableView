
import UIKit

public enum StarRounding: Int {
    
    case ceilToHalfStar = 1
    case floorToHalfStar = 2
    case roundToFullStar = 3
}

@IBDesignable
class StarRatingView: UIView {
    
    @IBInspectable var rating: Float = 3.0 {
        didSet {
            setStarsFor(rating: rating)
        }
    }
    @IBInspectable var starColor: UIColor = UIColor.systemOrange {
        didSet {
            for starImageView in [hstack?.star1ImageView, hstack?.star2ImageView, hstack?.star3ImageView] {
                starImageView?.tintColor = starColor
            }
        }
    }
    

    var starRounding: StarRounding = .roundToFullStar {
        didSet {
            setStarsFor(rating: rating)
        }
    }
    @IBInspectable var starRoundingRawValue:Int {
        get {
            return self.starRounding.rawValue
        }
        set {
            self.starRounding = StarRounding(rawValue: newValue) ?? .roundToFullStar
        }
    }
    
    fileprivate var hstack: StarRatingStackView?

    fileprivate let fullStarImage: UIImage = UIImage(systemName: "star.fill")!
    fileprivate let emptyStarImage: UIImage = UIImage(systemName: "star")!

    
    convenience init(frame: CGRect, rating: Float, color: UIColor, starRounding: StarRounding) {
        self.init(frame: frame)
        self.setupView(rating: rating, color: color, starRounding: starRounding)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView(rating: self.rating, color: self.starColor, starRounding: self.starRounding)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView(rating: 3.0, color: UIColor.systemOrange, starRounding: .roundToFullStar)
    }
    
    
    fileprivate func setupView(rating: Float, color: UIColor, starRounding: StarRounding) {
        let bundle = Bundle(for: StarRatingStackView.self)
        let nib = UINib(nibName: "StarRatingStackView", bundle: bundle)
        let viewFromNib = nib.instantiate(withOwner: self, options: nil)[0] as! StarRatingStackView
        self.addSubview(viewFromNib)
        
        viewFromNib.translatesAutoresizingMaskIntoConstraints = false
              self.addConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "H:|[v]|",
                    options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                    metrics: nil,
                    views: ["v":viewFromNib]
                 )
              )
              self.addConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "V:|[v]|",
                    options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                    metrics: nil, views: ["v":viewFromNib]
                 )
              )
        
        self.hstack = viewFromNib
        self.rating = rating
        self.starColor = color
        self.starRounding = starRounding
        
        self.isMultipleTouchEnabled = false
        self.hstack?.isUserInteractionEnabled = false
    }
    
    fileprivate func setStarsFor(rating: Float) {
        let starImageViews = [hstack?.star1ImageView, hstack?.star2ImageView, hstack?.star3ImageView]
        for i in 1...3 {
            let iFloat = Float(i)
            switch starRounding {
           
            case .ceilToHalfStar:
                starImageViews[i-1]!.image = rating >= iFloat-0.1 ? fullStarImage :
                    emptyStarImage
            case .floorToHalfStar:
                starImageViews[i-1]!.image = rating >= iFloat-0.1 ? fullStarImage :
                    emptyStarImage
            case .roundToFullStar:
                starImageViews[i-1]!.image = rating >= iFloat-0.1 ? fullStarImage : emptyStarImage
  
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches began")
        guard let touch = touches.first else {return}
        touched(touch: touch, moveTouch: false)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touched moved")
        guard let touch = touches.first else {return}
        touched(touch: touch, moveTouch: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touched ended")
        guard let touch = touches.first else {return}
        touched(touch: touch, moveTouch: false)
    }
    
    var lastTouch: Date?
    fileprivate func touched(touch: UITouch, moveTouch: Bool) {
        guard !moveTouch || lastTouch == nil || lastTouch!.timeIntervalSince(Date()) < -0.1 else { return }
        print("processing touch")
        guard let hs = self.hstack else { return }
        let touchX = touch.location(in: hs).x
        let ratingFromTouch = 3*touchX/hs.frame.width
        var roundedRatingFromTouch: Float!
        switch starRounding {
        case .ceilToHalfStar, .floorToHalfStar:
            roundedRatingFromTouch = Float(round(2*ratingFromTouch)/2)
        case .roundToFullStar:
            roundedRatingFromTouch = Float(round(ratingFromTouch))
        }
        self.rating = roundedRatingFromTouch
        lastTouch = Date()
    }
}
