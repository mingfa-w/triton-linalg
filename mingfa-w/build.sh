current_dir=$(cd $(dirname $0); pwd)
export rebuild=0 # 1-重新编译
TARGET_ARCH=`uname -m`
TRITON_MAJ_VER=e601be5d

# 下面参数要与utils/docker/Dockerfile中保持一致
APPS_PATH=/opt/apps
CODE_PATH=${APPS_PATH}/code
VENV_PATH=${APPS_PATH}/venv

# llvm-project version
LLVM_MAJ_VER=triton-e601be5d-llvm-10dc3a8e
# llvm_install_dir=${HOME}/.local/llvm-$LLVM_MAJ_VER-$TARGET_ARCH
llvm_install_dir=${APPS_PATH}/llvm_${LLVM_MAJ_VER}
echo llvm_install_dir=$llvm_install_dir
# python venv
py_venv_dir=${VENV_PATH}/triton-linalg

# triton path
src_dir=${current_dir}/..
triton_src_dir=${src_dir}/triton
triton_build_dir=${triton_src_dir}/python/build
triton_install_dir=${triton_build_dir}

# 处理参数
while getopts "rp:" opt
do
    case $opt in
        r)
            echo "选项 -r 被设置"
            rebuild=1
            ;;
        l)
            echo "选项 -l(llvm_install_dir) 的值是 $OPTARG"
            llvm_install_dir=$OPTARG
            ;;
        \?)
            echo "无效选项: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

function build_triton(){
    if [ ! -d ${triton_src_dir/python/build} ]; then
        rm -rf ${triton_src_dir/python/build}
    fi
    cd ${triton_src_dir}
    # source $HOME/apps/venv/python3112-triton/bin/activate
    source $py_venv_path
    # pip install ninja cmake wheel pybind11 # build-time dependencies
    http_proxy=http://sys-proxy-rd-relay.byted.org:3128 \
    https_proxy=http://sys-proxy-rd-relay.byted.org:3128 \
    no_proxy=.byted.org \
    DEBUG=1 \
    TRITON_PLUGIN_DIRS=${triton_linalg_src_dir} \
    LLVM_INCLUDE_DIRS=${llvm_install_dir}/include \
    LLVM_LIBRARY_DIR=${llvm_install_dir}/lib \
    LLVM_SYSPATH=${llvm_install_dir} \
    TRITON_BUILD_WITH_CLANG_LLD=true \
    TRITON_BUILD_WITH_CCACHE=true \
    TORCH_USE_CUDA_DSA=true \
    pip install -e python --no-build-isolation
    cd ${current_dir}
}

build_triton

echo "triton build done"
