import os
import argparse
from scalesim.scale_sim import scalesim

content_path = os.getcwd() #"D:/OneDrive/NYU/RA_WORK/Scalesim v2"
config = content_path + "/configs/scale.cfg"
topo = content_path + "/topologies/alexnet.csv"
netname = "alexnet"
#"D:\OneDrive\NYU\RA_WORK\Scalesim v2\topologies\topo_matlabnet.csv"
top = content_path + "/test_run" #"D:/OneDrive/NYU/RA_WORK/Scalesim v2/test_run"

s = scalesim(save_disk_space=True, verbose=True,
              config=config,
              topology=topo
              )

def run_sweep(arr_size, top = top):

    s.config.array_cols = arr_size
    s.config.array_rows = arr_size
    
    s.config.run_name = netname + "_" + s.config.df + str(s.config.array_cols) + "x" + str(s.config.array_rows)
    s.run_scale(top_path=top)

def main():
    # Create the parser
    parser = argparse.ArgumentParser(description="Example CLI using argparse")
    
    # Add an argument
    parser.add_argument('number', type=int, help="An integer number")
    
    # Parse the arguments
    args = parser.parse_args()

    run_sweep(args.number)


# Using the special variable 
# __name__
if __name__=="__main__":
    main()
