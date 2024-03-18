from selector import Selector
import matplotlib.pyplot as plt
import numpy as np
from particle import Particle_trajectory
from mpl_toolkits.mplot3d import Axes3D
from scipy.interpolate import RegularGridInterpolator


class Calculation:
    def __init__ (self,
                  space_size,
                  ax,
                  t_max
                  ):
      self.space_size = space_size
      self.ax = ax
      self.t_max = t_max


    def e_field_total(self,number_electric:list, resolution):
        z = np.linspace(0,self.space_size[0],self.space_size[0]*resolution)
        y = np.linspace(-self.space_size[1] / 2, self.space_size[1] / 2, self.space_size[2] * resolution)
        x = np.linspace(-self.space_size[2] / 2, self.space_size[2] / 2, self.space_size[2] * resolution)
        mesh_grid = np.meshgrid(z,y,x,indexing='ij')
        selector = Selector([8, 8, 8], number_electric, mesh_grid, self.ax)
        E_total = selector.x_selector(5.5, 0, 8, 14.5, 0) + selector.y_selector(23.5, 0, 8, 32.5, 0) 
        return E_total, mesh_grid, z, y, x
        

    
    def plot_E_field_total(self, downsampling_ratio, E_total, mesh_grid):
        ax = self.ax
        scale = 0.1
        ax.quiver(mesh_grid[0][::downsampling_ratio,::downsampling_ratio,::downsampling_ratio],
                mesh_grid[1][::downsampling_ratio,::downsampling_ratio,::downsampling_ratio],
                mesh_grid[2][::downsampling_ratio,::downsampling_ratio,::downsampling_ratio],
                E_total[0][::downsampling_ratio,::downsampling_ratio,::downsampling_ratio] * scale,
                E_total[1][::downsampling_ratio,::downsampling_ratio,::downsampling_ratio] * scale,
                E_total[2][::downsampling_ratio,::downsampling_ratio,::downsampling_ratio] * scale)
      
        
       
        
    def calculation_particle(self, E_total, z, y, x, init_state):
        
        interp_z = RegularGridInterpolator((z, y, x),E_total[0])
        interp_y = RegularGridInterpolator((z, y, x),E_total[1])
        interp_x = RegularGridInterpolator((z, y, x),E_total[2])
        trajectory = np.zeros((self.t_max, len(init_state)))
        trajectory[0,:] = init_state
        particle_trajectory = Particle_trajectory(10, 2, 0.01)
        for i in range(self.t_max):
            if trajectory[i,0]< 0 or trajectory[i, 0] > self.space_size[0]\
                or trajectory[i,1]< -self.space_size[1] / 2 or trajectory[i,1] > self.space_size[1] / 2\
                or trajectory[i,2]< -self.space_size[2] / 2 or trajectory[i,2] > self.space_size[2] / 2:
                trajectory = trajectory[0:i,:]
                break
            pos = trajectory[i, :3]
            E_at_particle = np.array([interp_z(pos), interp_y(pos), interp_x(pos)])
            trajectory[i+1,:] =  particle_trajectory.particle_state(E_at_particle, trajectory[i,:])
        return trajectory 
    
    def plot_particle_trajectory(self, trajectory):
            
            plt.quiver(trajectory[:-2, 0], trajectory[:-2, 1], trajectory[:-2, 2],
                   trajectory[1:-1, 0] - trajectory[:-2, 0],
                   trajectory[1:-1, 1] - trajectory[:-2, 1],
                   trajectory[1:-1, 2] - trajectory[:-2, 2],
                   )
   

if __name__ == "__main__":
    fig = plt.figure()
    ax = fig.gca(projection='3d')
    #ax = Axes3D(fig)
    ax.set_xlabel('z-axis')
    ax.set_ylabel('x-axis')
    ax.set_zlabel('y-axis')
    ax.set_zlim(-6, 6)
    ax.set_xlim(0, 40)
    ax.set_ylim(-6, 6)
    ax.autoscale(True)
    result = Calculation([40, 10, 10], ax, 10000)
    E_total, mesh_grid ,z, y, x= result.e_field_total([5, 5, 5],4)
    result.plot_E_field_total(7, E_total, mesh_grid)
    trajectory = result.calculation_particle(E_total, z, y, x, [0, -1, -1, 15, 0, 0])
    result.plot_particle_trajectory(trajectory)
    plt.show()                                             
    



