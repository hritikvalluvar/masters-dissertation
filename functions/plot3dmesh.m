function h = plot3dmesh(mesh, cdata, selector)
% Function for plotting tetrahedral mesh
% mesh: in NIRFAST format
% cdata: has the length of number of nodes. Can be e.g. mua, mus, Jacobian,
%       region, etc. Can be float numbers of rgb triplets
% selector (optional): making cuts to the mesh, e.g. 'x>10', 'x>10 & y>20',
%                      'y+z<50', 'x+y+z=100', 'y=50'
%                       If empty or not specified, the entire mesh is plotted
%
% Jiaming Cao 2023. Adapted from various iso2mesh (http://iso2mesh.sf.net) functions

if mesh.dimension ~=3
    error('Function only supports 3D meshes!')
end
if nargin<3
    selector = [];
end
if nargin<2 || isempty(cdata)
    cdata = ones(size(mesh.nodes,1),1);
end

node = mesh.nodes(:,1:3);
elem = mesh.elements(:,1:4);

if isempty(selector)
    face = openface(elem);
    h = trisurf(face(:,1:3),node(:,1),node(:,2),node(:,3),'facevertexcdata',cdata);
    axis off
elseif regexp(selector,'=')
    [cutpos,cutvalue,facedata] = qmeshcut(elem,node,cdata,selector);
    h = patch('Vertices', cutpos, 'Faces', facedata, 'FaceVertexCData', cutvalue, 'FaceColor', 'flat', 'EdgeColor', 'none');
else
    ec = reshape(node(elem',:)', [3, 4, size(elem,1)]);   % from meshcentroid.m
    centroid = squeeze(mean(ec,2))';
    x = centroid(:,1);
    y = centroid(:,2);
    z = centroid(:,3);
    idx = eval(['find(' selector ')']);
    if isempty(idx)
        warning('Selection out of range. Plotting the whole mesh.')
        face = openface(elem);
        h = trisurf(face(:,1:3),node(:,1),node(:,2),node(:,3),'facevertexcdata',cdata,'EdgeColor', [0.5, 0.5, 0.5], 'EdgeAlpha',0.1);
    else
        face = openface(elem(idx,:));
        h = trisurf(face(:,1:3),node(:,1),node(:,2),node(:,3),'facevertexcdata',cdata,'EdgeColor', [0.5, 0.5, 0.5], 'EdgeAlpha',0.1);
    end
    axis off
end
view(3)
axis equal

function face = openface(elem)
% find the open faces given elements
% from "surfedge.m"
edges = [elem(:,[1,2,3]);
       elem(:,[2,1,4]);
       elem(:,[1,3,4]);
       elem(:,[2,4,3])];
edgesort = sort(edges,2);
[~, ix, jx] = unique(edgesort,'rows');
vec = histcounts(jx,1:max(jx));
face = edges(ix(vec==1),:);
