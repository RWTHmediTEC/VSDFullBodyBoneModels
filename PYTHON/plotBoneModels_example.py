
from pathlib import Path
import scipy.io
import plotly.graph_objects as go

mod_path = Path(__file__).parent
relativePath = '../Bones/002.mat'
subjectPath = (mod_path / relativePath).resolve()
MAT = scipy.io.loadmat(subjectPath)

meshColor = 'white'
lightingEffects = dict(ambient=0.6, diffuse=1, roughness=0.5, specular=0.6, fresnel=2)
for b in range(0, MAT['B'].size):
    # Extract vertices and faces of one bone
    vertices = MAT['B'][0, b][2][0][0][0]
    # Subtract 1 from the faces for proper indexing
    faces = MAT['B'][0, b][2][0][0][1] - 1
    if b == 0:
        fig = go.Figure(go.Mesh3d(
            x=vertices[:, 0], y=vertices[:, 1], z=vertices[:, 2],
            i=faces[:, 0], j=faces[:, 1], k=faces[:, 2],
            opacity=1, color=meshColor, lighting=lightingEffects))
    else:
        fig.add_trace(go.Mesh3d(
            x=vertices[:, 0], y=vertices[:, 1], z=vertices[:, 2],
            i=faces[:, 0], j=faces[:, 1], k=faces[:, 2],
            opacity=1, color=meshColor, lighting=lightingEffects))

fig.update_scenes(camera_projection_type='orthographic')
fig['layout']['scene']['aspectmode'] = "data"
camera = dict(eye=dict(x=-2.5, y=-5, z=1))
fig.update_layout(scene_camera=camera)
axesSettings = dict(
    backgroundcolor="grey",
    gridcolor="white",
    showbackground=True,
    zerolinecolor="white")
fig.update_layout(scene=dict(
    xaxis=axesSettings,
    yaxis=axesSettings,
    zaxis=axesSettings))
fig.show()
