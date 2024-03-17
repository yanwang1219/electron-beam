import unittest
import numpy as np
from src.selector import Selector

class TestSeletor(unittest.TestCase):

    def test_calculate_single_E_field(self):
        z = np.linspace(0,1,2)
        y = np.linspace(0,1,2)
        x = np.linspace(0,1,2)
        mesh_grid = np.meshgrid(z,y,x)
        #print(mesh_grid[0].shape)
        selector = Selector((1, 2, 3), (1, 1, 1), mesh_grid)
        E = selector.calculate_single_E_field((0.5, 0.3, 0.5))
        expected_E = (
            np.array([[[-0.84745763, -0.84745763],[ 0.84745763,  0.84745763]],
                      [[-0.50505051, -0.50505051],[ 0.50505051,  0.50505051]]]),
            np.array([
                [[-0.50847458, -0.50847458], [-0.50847458, -0.50847458]],
                [[ 0.70707071,  0.70707071], [ 0.70707071,  0.70707071]]]),
            np.array([
                [[-0.84745763,  0.84745763], [-0.84745763,  0.84745763]],
                [[-0.50505051,  0.50505051], [-0.50505051,  0.50505051]]])
                )
        self.assertTrue((E[0].round(3) == expected_E[0].round(3)).all())

 