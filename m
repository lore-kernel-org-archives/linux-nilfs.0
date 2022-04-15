From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Subject: Re: [PATCH 26/27] block: decouple REQ_OP_SECURE_ERASE from
 REQ_OP_DISCARD
Date: Fri, 15 Apr 2022 05:51:29 +0000
Message-ID: <ad050f78-2d64-0ff9-a6b0-968cfa53eacf@nvidia.com>
References: <20220415045258.199825-1-hch@lst.de>
 <20220415045258.199825-27-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-bcache-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gg8hdgNEhj02MY/XmMdpyN8wb87wt0DFAivKrNj4n08=;
 b=VDfgTaSk5uOJnNTZAAWJSAbOvvp7Dt4od+YuLkDUMZ2ERormmWeB0Q+sPvkB5n8RJoFUxRkiwP+nDz2Fs35bmeYFbR6mPO7uQUMmz8n+49u7LUiIP7y7mFawzwK7yKMqEI8j4UQb9MnM2x3Ux28jnKdTq3TvNRrMh+Cd30qzvuh4VFhe5SOTf9k8SzDkKUBCFMDoLPfntk5xglLsaVsAJ0vk30HUrRpiyKMMuKHle45ZrfOjcTEmsdvFY6+fnxfZJUNzP25uVLHPMXEvhyITTPlYWasjDVq4Nqh/uR27m991It4FlP/HgYDyr4CYtAh1OK3Ou+7Afi6ldKj5DeFnFw==
In-Reply-To: <20220415045258.199825-27-hch@lst.de>
Content-Language: en-US
Content-ID: <C5A7864F5C266F4ABDCFD32C055621F9@namprd12.prod.outlook.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-um@lists.infradead.org" <linux-um@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "nbd@other.debian.org" <nbd@other.debian.org>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>

T24gNC8xNC8yMiAyMTo1MiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFNlY3VyZSBlcmFz
ZSBpcyBhIHZlcnkgZGlmZmVyZW50IG9wZXJhdGlvbiBmcm9tIGRpc2NhcmQgaW4gdGhhdCBpdCBp
cw0KPiBhIGRhdGEgaW50ZWdyaXR5IG9wZXJhdGlvbiB2cyBoaW50LiAgRnVsbHkgc3BsaXQgdGhl
IGxpbWl0cyBhbmQgaGVscGVyDQo+IGluZnJhc3RydWN0dXJlIHRvIG1ha2UgdGhlIHNlcGFyYXRp
b24gbW9yZSBjbGVhci4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxo
Y2hAbHN0LmRlPg0KPiBSZXZpZXdlZC1ieTogTWFydGluIEsuIFBldGVyc2VuIDxtYXJ0aW4ucGV0
ZXJzZW5Ab3JhY2xlLmNvbT4NCj4gQWNrZWQtYnk6IENocmlzdG9waCBCw7ZobXdhbGRlciA8Y2hy
aXN0b3BoLmJvZWhtd2FsZGVyQGxpbmJpdC5jb20+IFtkcmJkXQ0KPiBBY2tlZC1ieTogUnl1c3Vr
ZSBLb25pc2hpIDxrb25pc2hpLnJ5dXN1a2VAZ21haWwuY29tPiBbbmlmczJdDQo+IEFja2VkLWJ5
OiBKYWVnZXVrIEtpbSA8amFlZ2V1a0BrZXJuZWwub3JnPiBbZjJmc10NCj4gQWNrZWQtYnk6IENv
bHkgTGkgPGNvbHlsaUBzdXNlLmRlPiBbYmNhY2hlXQ0KPiBBY2tlZC1ieTogRGF2aWQgU3RlcmJh
IDxkc3RlcmJhQHN1c2UuY29tPiBbYnRyZnNdDQo+IC0tLQ0KDQpMb29rcyBnb29kLg0KDQpSZXZp
ZXdlZC1ieTogQ2hhaXRhbnlhIEt1bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4NCg0KLWNrDQoNCg==
