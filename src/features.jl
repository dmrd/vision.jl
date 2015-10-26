using VLFeat
using Images

# Return [keypoints, descriptor]
# keypoints: Each column is a feature frame and has the format [X;Y;S;TH], where X,Y is the (fractional) center of the frame, S is the scale and TH is the orientation (in radians). [from VLFeat documentation]
# descriptors: 128xn array of x,y points
sift(im::Image) = VLFeat.vl_sift(im)
