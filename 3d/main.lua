local skybox

function lovr.load()
  lovr.setMode({width = 800, height = 800})
  skybox = lovr.graphics.newTexture('assets/equirectangular.png')
end

function lovr.draw(pass)
  pass:skybox(skybox)
end
