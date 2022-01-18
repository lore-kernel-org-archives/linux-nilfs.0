From: Chaitanya Kulkarni <chaitanyak-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 15/19] block: pass a block_device and opf to
 bio_alloc_bioset
Date: Tue, 18 Jan 2022 22:12:25 +0000
Message-ID: <c4d0db2c-b487-e965-30da-507b30f29a6e@nvidia.com>
References: <20220118071952.1243143-1-hch@lst.de>
 <20220118071952.1243143-16-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uQcGE2RD5vm8sY+bJefQtU5ebnJe2jUx0ztTnDFLA3c=;
 b=JcmykTlfYTcbTqgMj5FEPa54w1Z8qFwrH0IeEPNKrDXFeA1YFSO2fnxbvP11fmdOkeJgkztshHDES3uqwAzgTf2xwUGlenrJL0ybkjmUDq1RWNupkP8c8kcetY7FKDMuiuIb39d/TXnzKvzu6nfueR2B0DlWZ0MOiT0S4ZiAxJi2HWJaaoKvYJfV779dHnVWTGMn5aoFYMxuWBiVTtslEiMAX/J9bYKOV2RBPrxu+r2cJHVGDxoVIsWPsUrJ/PKPIJ4Nf6YHRKYHMb4K0CtUoojKceim3khQk//bTbPZgYsVeeZdQOOyfolvacKzbpk8BbvXWQp+PhK2a9g3+PlaTQ==
In-Reply-To: <20220118071952.1243143-16-hch-jcswGhMUV9g@public.gmane.org>
Content-Language: en-US
Content-ID: <E00E6E42D2517540A652FBBB17F3A16F-asWib9pRmPqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Konstantin Komarov <almaz.alexandrovich-m5I1DM4ARimttCpgsWEBFlaTQe2KTcn/@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Md . Haris Iqbal" <haris.iqbal-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Jack Wang <jinpu.wang-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, =?utf-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau-Sxgqhf6Nn4Bhl2p70BpVqQ@public.gmane.org>, Philipp Reisner <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ntfs3-cunTk1MwBs/YUNznpcFYbw@public.gmane.org" <ntfs3@l>

T24gMS8xNy8yMiAxMToxOSBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFBhc3MgdGhl
IGJsb2NrX2RldmljZSBhbmQgb3BlcmF0aW9uIHRoYXQgd2UgcGxhbiB0byB1c2UgdGhpcyBiaW8g
Zm9yIHRvDQo+IGJpb19hbGxvY19iaW9zZXQgdG8gb3B0aW1pemUgdGhlIGFzc2lnbWVudC4gIE5V
TEwvMCBjYW4gYmUgcGFzc2VkLCBib3RoDQo+IGZvciB0aGUgcGFzc3Rocm91Z2ggY2FzZSBvbiBh
IHJhdyByZXF1ZXN0X3F1ZXVlIGFuZCB0byB0ZW1wb3JhcmlseSBhdm9pZA0KPiByZWZhY3Rvcmlu
ZyBzb21lIG5hc3R5IGNvZGUuDQo+IA0KPiBBbHNvIG1vdmUgdGhlIGdmcF9tYXNrIGFyZ3VtZW50
IGFmdGVyIHRoZSBucl92ZWNzIGFyZ3VtZW50IGZvciBhIG11Y2gNCj4gbW9yZSBsb2dpY2FsIGNh
bGxpbmcgY29udmVudGlvbiBtYXRjaGluZyB3aGF0IG1vc3Qgb2YgdGhlIGtlcm5lbCBkb2VzLg0K
PiANCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQoNCg0K
TG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8a2NoQG52aWRp
YS5jb20+DQoNCg0K
