# 推导

Rodrigues vector, 旋转矩阵与四元数相互转换

```cpp

#include <opencv2/core/core.hpp>
#include <opencv2/calib3d/calib3d.hpp>
void mat2quat(cv::Mat R, double Q[])
{
    double trace = R.at<double>(0,0) + R.at<double>(1,1) + R.at<double>(2,2);
 
    if (trace > 0.0) 
    {
        double s = sqrt(trace + 1.0);
        Q[3] = (s * 0.5);
        s = 0.5 / s;
        Q[0] = ((R.at<double>(2,1) - R.at<double>(1,2)) * s);
        Q[1] = ((R.at<double>(0,2) - R.at<double>(2,0)) * s);
        Q[2] = ((R.at<double>(1,0) - R.at<double>(0,1)) * s);
    } 
    
    else 
    {
        int i = R.at<double>(0,0) < R.at<double>(1,1) ? (R.at<double>(1,1) < R.at<double>(2,2) ? 2 : 1) : (R.at<double>(0,0) < R.at<double>(2,2) ? 2 : 0); 
        int j = (i + 1) % 3;  
        int k = (i + 2) % 3;

        double s = sqrt(R.at<double>(i, i) - R.at<double>(j,j) - R.at<double>(k,k) + 1.0);
        Q[i] = s * 0.5;
        s = 0.5 / s;

        Q[3] = (R.at<double>(k,j) - R.at<double>(j,k)) * s;
        Q[j] = (R.at<double>(j,i) + R.at<double>(i,j)) * s;
        Q[k] = (R.at<double>(k,i) + R.at<double>(i,k)) * s;
    }
}

void quat2mat(double *q2, cv::Mat &rot_mat) {
    double q[4];
    q[0] = q2[3];
    q[1] = q2[0];
    q[2] = q2[1];
    q[3] = q2[2];
    // double *q = q2;
    double x[3][3];
    x[0][0] = 1 - 2 * (q[2]*q[2] + q[3] * q[3]);
    x[0][1] = 2 * (q[1] * q[2] - q[0]*q[3]);
    x[0][2] = 2 * (q[1] * q[3] + q[0] * q[2]);
    x[1][0] = 2 * (q[1] * q[2] + q[0] * q[3]);
    x[1][1] = 1 - 2 *(q[1] * q[1] + q[3] * q[3]);
    x[1][2] = 2 * (q[2] * q[3] - q[0] * q[1]);
    x[2][0] = 2 * (q[1] * q[3] - q[0] * q[2]);
    x[2][1] = 2 * (q[2] * q[3] + q[0] * q[1]);
    x[2][2] = 1 - 2 * (q[1] * q[1] + q[2] * q[2]);
    rot_mat = cv::Mat(3, 3, CV_64F, x);
    std::cout << rot_mat << std::endl;
}

int rotation_main() {
    double r_vec[3] = {0.35710906, -2.29245728, -0.60095994};
    cv::Mat rot_vec(3, 1, CV_64F, r_vec);
    cv::Mat rot_mat;
    cv::Rodrigues(rot_vec, rot_mat);
    std::cout<<rot_mat<<std::endl;
    double q[4];
    mat2quat(rot_mat, q);
    cv::Mat new_mat;
    quat2mat(q, new_mat);
    
    return 0;
}

int main() {
    rotation_main();
    return 0;
}
```