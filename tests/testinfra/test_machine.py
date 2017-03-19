import pytest

# To Run From The Parent Directory:
# testinfra -v --ansible-inventory=ansible/inventory/vagrant.py --connection=ansible tests/testinfra/


def test_connnection(TestinfraBackend):
    conn_type = TestinfraBackend.get_connection_type()
    assert conn_type is not None


def test_ping(Ansible):
    ping_result = Ansible("ping")
    assert ping_result is not None


@pytest.mark.parametrize("name", [
    "monit",
    "ntp",
    "wget",
    "curl",
    "unzip",
    "git",
])
def test_package_is_installed(Package,name):
    assert Package(name).is_installed


@pytest.mark.parametrize("name", [
    "monit",
])
def test_service_running_and_enabled(Service, name):
    assert Service(name).is_running
    assert Service(name).is_enabled

