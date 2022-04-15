From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Subject: Re: [PATCH 22/27] block: refactor discard bio size limiting
Date: Fri, 15 Apr 2022 05:46:32 +0000
Message-ID: <d3f73a4f-0d45-6627-7878-9b5acd47842f@nvidia.com>
References: <20220415045258.199825-1-hch@lst.de>
 <20220415045258.199825-23-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ll6nOnUsFN4t09CavEjEFdgdIftb6EE+wpAq2T7XWI8=;
 b=ppRLTkwLk6uegRJ2kfkGhWth1BBuonhTnRrzZ9Un7tjuB0GULPSRiaczQgUkJsyzpYnevIx+ZFRiDRhQIR/udWanzMKbOuvh6xNUzIgKfw2LeV3XTqYPKNm9KrNPUr/EqJ+v8Vu8lBWcpvEWCKdFTiZu8/Y/bpycbLdnGnMpP74amXzuPEo6m2kAo+rfWauBp/tVU7gLcfg+1KAVsP7A4GLeLtKoyI2G+ClrLlQuWeRfEigiQd6QWBHxQYpzbWto1yEQT43IV17ysfDx3I713iJzzSIELWtCGagp+9269anNe6S76f29QxYfpaZYBOBHZk6za0WIxP/ECbVELFUhpg==
In-Reply-To: <20220415045258.199825-23-hch@lst.de>
Content-Language: en-US
Content-ID: <5C40943C50889249AD34D58B6AD3A631@namprd12.prod.outlook.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-um@lists.infradead.org" <linux-um@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "nbd@other.debian.org" <nbd@other.debian.org>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>

T24gNC8xNC8yMiAyMTo1MiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IE1vdmUgYWxsIHRo
ZSBsb2dpYyB0byBsaW1pdCB0aGUgZGlzY2FyZCBiaW8gc2l6ZSBpbnRvIGEgY29tbW9uIGhlbHBl
cg0KPiBzbyB0aGF0IGl0IGlzIGJldHRlciBkb2N1bWVudGVkLg0KPiANCj4gU2lnbmVkLW9mZi1i
eTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQo+IFJldmlld2VkLWJ5OiBNYXJ0aW4g
Sy4gUGV0ZXJzZW4gPG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tPg0KPiBBY2tlZC1ieTogQ29s
eSBMaSA8Y29seWxpQHN1c2UuZGU+DQo+IC0tLQ0KDQpMb29rcyBnb29kLg0KDQpSZXZpZXdlZC1i
eTogQ2hhaXRhbnlhIEt1bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4NCg0KLWNrDQoNCg==
