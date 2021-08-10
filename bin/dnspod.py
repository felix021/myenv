#!/usr/bin/python
#coding:utf-8

import requests
import json
import socket

login_token = "YOUR LOGIN TOKEN HERE"
domain_name = "YOUR_DOMAIN_NAME.com"
record_name = "YOUR_RECORD_NAME"

def DomainInfo(token, domain):
    rsp = requests.post("https://dnsapi.cn/Domain.Info", data={
        "format": "json",
        "login_token": token,
        "domain": domain,
    })
    data = rsp.json()
    if data.get('status', {}).get('code') != "1":
        raise Exception("DomainInfo failed: " + json.dumps(data, ensure_ascii="False"))
    return data


def RecordList(token, domain_id):
    rsp = requests.post("https://dnsapi.cn/Record.List", data={
        "format": "json",
        "login_token": token,
        "domain_id": domain_id,
    })
    return rsp.json()

def getPublicIP():
    sock = socket.create_connection(('ns1.dnspod.net', 6666))
    ip = sock.recv(16)
    sock.close()
    return ip

def RecordDdns(token, domain_id, record_id, sub_domain, ip):
    rsp = requests.post("https://dnsapi.cn/Record.List", data={
        "format": "json",
        "login_token": token,
        "domain_id": domain_id,
        "record_id": record_id,
        "sub_domain": sub_domain,
        "record_line": "默认",
        "value": ip,
    })
    print json.dumps(rsp.json(), ensure_ascii=False, indent=4)

def getDomainIdByDomainName(token ,domain):
    domain = DomainInfo(token, domain)
    return domain["domain"]["id"]

def getRecordByName(token, domain_id, record_name):
    records = RecordList(login_token, domain_id)
    if records.get('status', {}).get('code') != "1":
        raise Exception("RecordList failed: " + json.dumps(records, ensure_ascii="False"))
    for record in records['records']:
        if record['name'] == record_name:
            return record
    raise Exception("getRecordByName: no match record in " + json.dumps(records, ensure_ascii="False"))

domain_id = getDomainIdByDomainName(login_token, domain_name)
record = getRecordByName(login_token, domain_id, record_name)
RecordDdns(login_token, domain_id, record['id'], record['name'], getPublicIP())
