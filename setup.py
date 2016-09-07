# from setuptools import setup, find_packages

# setup(
    # name='sample',
    # version='1.0',
    # long_description=__doc__,
    # install_requires=[
        # # 'Flask'
        # 'click'
    # ],
    # include_package_data=True,
    # zip_safe=False,
    # entry_points="""
        # [console_scripts]
            # sample = sample.main:main
    # """,
    # packages=find_packages('src'),
    # package_dir={'': 'src'},
# )

from setuptools import setup, find_packages
import os.path


def project_path(*names):
    return os.path.join(os.path.dirname(__file__), *names)

long_description = []

setup(
    name='sample',
    version='1.0',
    install_requires=[
        'Flask',
    ],
    entry_points="""
        [console_scripts]
            sample = sample.main:main
    """,
    packages=find_packages('src'),
    package_dir={'': 'src'},
    include_package_data=True,
    zip_safe=False
)
