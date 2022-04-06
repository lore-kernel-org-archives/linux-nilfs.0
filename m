From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/27] target: fix discard alignment on partitions
Date: Wed,  6 Apr 2022 08:04:52 +0200
Message-ID: <20220406060516.409838-4-hch@lst.de>
References: <20220406060516.409838-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20220406060516.409838-1-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
Content-Type: text/plain; charset="windows-1252"
To: Jens Axboe <axboe@kernel.dk>
Cc: jfs-discussion@lists.sourceforge.net, linux-nvme@lists.infradead.org, virtualization@lists.linux-foundation.org, linux-mm@kvack.org, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, drbd-dev@lists.linbit.com, linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, cluster-devel@redhat.com, xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, linux-um@lists.infradead.org, nbd@other.debian.org, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, ceph-devel@vger.kernel.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, ntfs3@lists.linux.dev, linux-btrfs@vger.kernel.org

VXNlIHRoZSBwcm9wZXIgYmRldl9kaXNjYXJkX2FsaWdubWVudCBoZWxwZXIgdGhhdCBhY2NvdW50
cyBmb3IgcGFydGl0aW9uCm9mZnNldHMuCgpG0ZZ4ZXM6IGM2NmFjOWRiOGQ0YSAoIltTQ1NJXSB0
YXJnZXQ6IEFkZCBMSU8gdGFyZ2V0IGNvcmUgdjQuMC4wLXJjNiIpClNpZ25lZC1vZmYtYnk6IENo
cmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPgotLS0KIGRyaXZlcnMvdGFyZ2V0L3RhcmdldF9j
b3JlX2RldmljZS5jIHwgNCArKy0tCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAy
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvdGFyZ2V0L3RhcmdldF9jb3JlX2Rl
dmljZS5jIGIvZHJpdmVycy90YXJnZXQvdGFyZ2V0X2NvcmVfZGV2aWNlLmMKaW5kZXggM2ExZWM3
MDVjZDgwYi4uMTZlNzc1YmNmNGE3YyAxMDA2NDQKLS0tIGEvZHJpdmVycy90YXJnZXQvdGFyZ2V0
X2NvcmVfZGV2aWNlLmMKKysrIGIvZHJpdmVycy90YXJnZXQvdGFyZ2V0X2NvcmVfZGV2aWNlLmMK
QEAgLTg0OSw4ICs4NDksOCBAQCBib29sIHRhcmdldF9jb25maWd1cmVfdW5tYXBfZnJvbV9xdWV1
ZShzdHJ1Y3Qgc2VfZGV2X2F0dHJpYiAqYXR0cmliLAogCSAqLwogCWF0dHJpYi0+bWF4X3VubWFw
X2Jsb2NrX2Rlc2NfY291bnQgPSAxOwogCWF0dHJpYi0+dW5tYXBfZ3JhbnVsYXJpdHkgPSBxLT5s
aW1pdHMuZGlzY2FyZF9ncmFudWxhcml0eSAvIGJsb2NrX3NpemU7Ci0JYXR0cmliLT51bm1hcF9n
cmFudWxhcml0eV9hbGlnbm1lbnQgPSBxLT5saW1pdHMuZGlzY2FyZF9hbGlnbm1lbnQgLwotCQkJ
CQkJCQlibG9ja19zaXplOworCWF0dHJpYi0+dW5tYXBfZ3JhbnVsYXJpdHlfYWxpZ25tZW50ID0K
KwkJYmRldl9kaXNjYXJkX2FsaWdubWVudChiZGV2KSAvIGJsb2NrX3NpemU7CiAJcmV0dXJuIHRy
dWU7CiB9CiBFWFBPUlRfU1lNQk9MKHRhcmdldF9jb25maWd1cmVfdW5tYXBfZnJvbV9xdWV1ZSk7
Ci0tIAoyLjMwLjIKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29t
Cmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

