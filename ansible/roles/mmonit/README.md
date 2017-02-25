# Ansible Role: M/Monit

[![Build Status](https://travis-ci.org/tschifftner/ansible-role-mmonit.svg)](https://travis-ci.org/tschifftner/ansible-role-mmonit)

Installs M/Monit on Debian/Ubuntu linux servers.

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    mmonit_license_owner: "Tildeslash Ltd. - Trial License"
    mmonit_license: |
      DDP65V2CBO-44Q6X5QOJU-WWOL4JEQUW-NPCHGAR7ED-XCNAVOUJBK
      LW5VLVSGK2-PZLJSRZVJA-LRRWGH3WYS-E7564FIMOH-FQ5XSU4RSD
      OHSEM3EKIT-SIEAF4K5F2-GGNPGT4FBN-MADSO54BOC-Z6M4ZSSAKD
      B4QISH6K55-HYQT3DSY2R-LP44IMUG7X-SVIYOACSUX-V4OQ3ODMXN
      4FWIQ
    
    
    mmonit_connectors:
      - name: 'Default'
        address: '*'
        port: 2811
        processors: 10
    
    mmonit_workspace: '/opt'
    
    mmonit_admin_username: 'admin'
    mmonit_admin_password: ''
    
    mmonit_connector_username: 'connector'
    mmonit_connector_password: ''

## Secure Monit connector

    mmonit_connectors:
      - name: 'Secured'
        scheme: https
        address: '*'
        port: 8443
        processors: 10
        secure: true

## Dependencies

None.

## Example Playbook

    - hosts: server
      roles:
        - { role: tschifftner.mmonit }

## Login

| Url | Username | Password |
|--- |--- |--- |
| http://www.example.org:2811 | admin | swordfish |

Please change the credentials within your project!

## License

[MIT License](http://choosealicense.com/licenses/mit/)

## Author Information

 - [Tobias Schifftner](https://twitter.com/tschifftner), [ambimax® GmbH](https://www.ambimax.de)