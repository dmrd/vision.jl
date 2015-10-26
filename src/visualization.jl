using Colors
using ImageView

function show_points(im::Image, keypoints::Array{Float64, 2})
    imgc, imsl = ImageView.view(im)
    for i = 1:size(keypoints, 2)
        x, y = keypoints[1:2, i]
        ImageView.annotate!(imgc, imsl, ImageView.AnnotationPoint(x, y, shape='+', size=20, color=Colors.RGB(1,0,0)))
    end
end
