#ifndef MATCHING_H
#define MATCHING_H

#include "ros/ros.h"
#include "sensor_msgs/PointCloud.h"
#include "std_msgs/Float64.h"
#include "std_msgs/Float64MultiArray.h"
#include "matlabCppInterface/Engine.hpp"
#include <boost/cstdint.hpp>
#include <math.h>

class matching{
  
  ros::NodeHandle n;

  // Static Engine
  static matlab::Engine engine;

  // Publishers
  ros::Publisher se_r_pub;

  // Pointcloud Vector
  Eigen::VectorXd xi;		// X-Vector of pointcloud transformed around inital values
  Eigen::VectorXd zi;		// Z-Vector of pointcloud transformed around inital values
  Eigen::VectorXd xf;		// Common X-Vector of transformed pointcloud and optimized template
  Eigen::VectorXd zf;		// Z-Vector of transformed
  Eigen::VectorXd z_r;		// Z-Vector of optimized template

  // Transform Parameters
  double phi;
  double dzi;
  int fov_s;
  int fov_d;

  // Initial and Result Vector
  Eigen::VectorXd v0;
  Eigen::VectorXd v_r;

  // Error of fminsearch()
  double se_r;
  
  // Helper to transform each laser scan accordingly
  int h;


public:
  matching() {};
  matching(ros::NodeHandle n_,double phi_,double dzi_,int fov_s_,int fov_d_,std::vector<double> &v0_,int h_);
 // std::vector<double> getResultVector();
  void matchCallback(const sensor_msgs::PointCloud::ConstPtr& msg);
  void matchTemplate();
  void publishSe_r();
  Eigen::VectorXd getV_r() {return v_r;};
  double getDx() {return fmod(v_r(2),sqrt(v_r(0)*v_r(0)+v_r(1)*v_r(1)));}
  double getSe_r() {return se_r;}
};

#endif
