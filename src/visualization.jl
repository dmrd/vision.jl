using Colors
using ImageView

function show_points(im::Image, keypoints::Array{Float64, 2})
    imgc, imsl = ImageView.view(im)
    for i = 1:size(keypoints, 2)
        x, y = keypoints[1:2, i]
        ImageView.annotate!(imgc, imsl, ImageView.AnnotationPoint(x, y, shape='+', size=20, color=Colors.RGB(1,0,0)))
    end
end

# Places images side by side and draws corresponces between them
# matches; array of [ax, ay, bx, by] points
function show_matches(a::Image, b::Image, matches)
    im, sizeA = sidebyside(a, b)
    offsetB = sizeA[1]  # X dim of A is offset for b coordinates
    imgc, imsl = ImageView.view(im)
    for i = 1:size(matches, 2)
        xa, ya, xb, yb = matches[1:4, i]
        xb += offsetB
        ImageView.annotate!(imgc, imsl, ImageView.AnnotationPoint(xa, ya, shape='+', size=5, color=Colors.RGB(1,0,0)))
        ImageView.annotate!(imgc, imsl, ImageView.AnnotationPoint(xb, yb, shape='+', size=5, color=Colors.RGB(1,0,0)))
        ImageView.annotate!(imgc, imsl, ImageView.AnnotationLine(xa, ya, xb, yb, linewidth=1, color=Colors.RGB(1,0,0)))
    end
end

# Concatenate images so we can use ImageView annotations to draw lines
function sidebyside(a::Image, b::Image)
    prop = a.properties
    maxx = max(size(a, 1), size(b, 1))
    maxy = max(size(a, 2), size(b, 2))
    a = padarray(a, [0,0], [maxx - size(a, 1), maxy - size(a, 2)], "replicate")
    b = padarray(b, [0,0], [maxx - size(b, 1), maxy - size(b, 2)], "replicate")
    println(size(a))
    println(size(b))
    c = Images.Image(vcat(Images.data(a), Images.data(b)), prop)
    return (c, size(a))
end
