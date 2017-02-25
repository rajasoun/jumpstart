import pytest


# To Run From The Parent Directory:
# testinfra -v --ansible-inventory=ansible/inventory/vagrant.py --connection=ansible tests/testinfra/test_web.py


def test_connnection(TestinfraBackend):
    conn_type = TestinfraBackend.get_connection_type()
    assert conn_type is not None


# def test_ping(Ansible):
#     ping_result = Ansible("ping")
#     assert ping_result is not None



# @pytest.mark.parametrize("name,version", [
#     ("nginx", "1.10.2"),
# ])
# def test_packages(Package, name, version):
#     assert Package(name).is_installed
#     assert Package(name).version.startswith(version)


# @pytest.mark.parametrize("name", [
#     "nginx",
#     "monit",
# ])
# def test_service_running_and_enabled(Service, name):
#     assert Service(name).is_running
#     assert Service(name).is_enabled

