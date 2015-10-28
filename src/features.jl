using VLFeat
using Images
using Distances

# Return [keypoints, descriptor]
# keypoints: Each column is a feature frame and has the format [X;Y;S;TH], where X,Y is the (fractional) center of the frame, S is the scale and TH is the orientation (in radians). [from VLFeat documentation]
# descriptors: 128xn array of x,y points
sift(im::Image) = VLFeat.vl_sift(im)



# Find matches (returns 2xn array of matches)
# Returns ([2xm array of matches], [euclidean distance measures])
# TODO: Replace with FLANN
# match A to B iff dist(A, B) * threshold < dist(A, [all other matches])
function find_matches(siftA, siftB, threshold::Float64)
    # Yes, this is very brute force right now
    nA = size(siftA, 2)
    nB = size(siftB, 2)
    bestIndex = zeros(Float32, nA)
    bestValue = fill(inf(Float32), nA)
    secondValue = fill(inf(Float32), nA)
    matchFlag = fill(false, nA)
    nMatches = 0
    for a = 1:nA
        for b = 1:nB
            dist = euclidean(siftA[:, a], siftB[:, b])
            if dist < bestValue[a]
                if bestValue[a] < secondValue[a]
                    secondValue[a] = bestValue[a]
                end
                bestValue[a] = dist
                bestIndex[a] = b
            end
        end
        if bestValue[a] < secondValue[a] * threshold
            matchFlag[a] = true
            nMatches += 1
        end
    end
    matches = zeros(Int32, 2, nMatches)
    dists = zeros(Float32, nMatches)
    cMatch = 1
    for a = 1:nA
        if matchFlag[a]
            matches[1, cMatch] = a
            matches[2, cMatch] = bestIndex[a]
            dists[cMatch] = bestValue[a]
            cMatch += 1
        end
    end
    return (matches, dists)
end

function indices_to_coordinates(coordsA, coordsB, matches)
    coords = zeros(Float32, 4, size(matches, 2))
    for match = 1:size(matches, 2)
        coords[1:2, match] = coordsA[:, matches[1, match]] 
        coords[3:4, match] = coordsB[:, matches[2, match]] 
    end
    return coords
end
