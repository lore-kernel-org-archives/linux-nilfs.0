From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Subject: Re: [PATCH 14/27] block: add a bdev_stable_writes helper
Date: Fri, 15 Apr 2022 05:42:30 +0000
Message-ID: <3a257cff-628b-e03e-e539-fda51a9ebad9@nvidia.com>
References: <20220415045258.199825-1-hch@lst.de>
 <20220415045258.199825-15-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <xen-devel-bounces@lists.xenproject.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.xenproject.org/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xenproject.org>
List-Help: <mailto:xen-devel-request@lists.xenproject.org?subject=help>
List-Subscribe: <https://lists.xenproject.org/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xenproject.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xenproject.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i63dxVhBes5m7cPwLoD+A13NfCaI28iV9y4PoA3bvMA=;
 b=rPgk33sgBEZSP/Ovm7jvsz640IYdyFvdM1fnM3lU6m7hGyj/mWMg6EjvUnHN7MbENCPEl6B+GzAIQaOFxp5xfiWrefupuWBvxHL+PgSXw1OCMSh0PcIokAm8WOCYnl1njdMmUi5oCY4Gw9qBkq6gSLZnrWSAlcI53nwvVVpbv4T/7VXZt8rnTjgH4EonEpnVATg3odZIT0zEG2nLh/hoHGpgFEUMCk69GbLgQ2mGc1pYX3UNAraZuE012TWuofQ/IJqZ3PGvHiqEQOaIeD/zc9Gn6iofz5djOWF9l2i2/bT4Jj9e+rMAdJs16xkW+gFk4KU4rptnTfDJHCOAzH/gzw==
In-Reply-To: <20220415045258.199825-15-hch@lst.de>
Content-Language: en-US
Content-ID: <BC25D9F96CBBE841BBAF019B54F927FD@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-um@lists.infradead.org" <linux-um@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "nbd@other.debian.org" <nbd@other.debian.org>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, linux-nvme@lists.infradead.o

T24gNC8xNC8yMiAyMTo1MiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEFkZCBhIGhlbHBl
ciB0byBjaGVjayB0aGUgc3RhYmxlIHdyaXRlcyBmbGFnIGJhc2VkIG9uIHRoZSBibG9ja19kZXZp
Y2UNCj4gaW5zdGVhZCBvZiBoYXZpbmcgdG8gcG9rZSBpbnRvIHRoZSBibG9jayBsYXllciBpbnRl
cm5hbCByZXF1ZXN0X3F1ZXVlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3
aWcgPGhjaEBsc3QuZGU+DQo+IFJldmlld2VkLWJ5OiBNYXJ0aW4gSy4gUGV0ZXJzZW4gPG1hcnRp
bi5wZXRlcnNlbkBvcmFjbGUuY29tPg0KPiAtLS0NCg0KTG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQt
Ynk6IENoYWl0YW55YSBLdWxrYXJuaSA8a2NoQG52aWRpYS5jb20+DQoNCi1jaw0KDQo=

