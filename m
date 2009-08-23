From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Fail to mount NILFS.
Date: Sun, 23 Aug 2009 17:20:53 +0900 (JST)
Message-ID: <20090823.172053.111144710.ryusuke@osrg.net>
References: <200908221936.12308.yuri@itinteg.net>
	<20090823.122322.09561031.ryusuke@osrg.net>
	<200908230755.02831.yuri@itinteg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Sun_Aug_23_17_20_53_2009_459)--"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <200908230755.02831.yuri-EJC0RcYdacHR7s880joybQ@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, yuri-EJC0RcYdacHR7s880joybQ@public.gmane.org

----Next_Part(Sun_Aug_23_17_20_53_2009_459)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi,
On Sun, 23 Aug 2009 07:55:02 +0300, Yuri Chislov wrote:
> On Sunday 23 August 2009 06:23:22 Ryusuke Konishi wrote:
> > If the new script find the blocks storing the root inode, it will also
> > dump them to files like:
> >
> > ifile-2-seg649-1329203
> > ifile-2-seg649-1329259
> > ifile-2-seg649-1329315
> > ifile-2-seg649-1329372
> > ifile-2-seg649-1329428
> > ifile-2-seg649-1329455
> >
> > Then, we can see if the root inode is actually broken or not.
> Hi,
> 
>  There is output from script.
> sudo ./find_root.sh /dev/cciss/c0d1p1 10938 | tee -a segment-with-root-
> inode.log
> find_root.sh: root inode not found
> 
> Thanks.
> Yuri.

Thank you for following this analysis.

It reached the beginning of the partition.

What will happen if you start the script from the last segment number?

The last segment number is calculated from the block count which
appears in /proc/partitions:

 $ cat /proc/partitions
major minor  #blocks  name

   8       16   71687325 sdb
   8       17   35840983 sdb1
   8       18   35841015 sdb2

 $ expr 35840983 / 4 / 2048 - 1
 4374
 $ sudo ./find-root.sh /dev/sdb1 4374


And, the attached patch will output some information about how disk
block numbers are converted with DAT file.

I think this will give another hint on which metadata broke in nilfs.

Could you apply it and try mount again?

Thanks in advance,
Ryusuke Konishi

----Next_Part(Sun_Aug_23_17_20_53_2009_459)--
Content-Type: Application/Octet-Stream
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="0001-nilfs2-add-debug-messages-on-bmap-lookup-and-dat-tra.patch.bz2"

QlpoOTFBWSZTWetEMOYAAf/fgEgwc3///3/vXk6//99uUAR57bud2c5s7u7sSqglFGoZNTT0mnkj
ymh6j1PUY1HqA0BkZD1Bk9JoGkATRpqbSaj1ND1DQ0DRk0B6jQAADIJT1KaAim1PamEjyg0DIaaA
AZAAANDjJk0YhpoYCaGJo0yYgZGE0aaYQZMJJE0JgIYibUwU8oGmJo00DQ0AGjJoy1hRIGEJiGJS
YZEQlDb/ZKIwIUmRVHXy5s9yykczLp6lK6BgaedJ3IrC60nLdyg2+oIogfkwbBsss0gSiUEkVuBL
/BEWgQd12P5kUPHNVEEqQkwOBOGmzy4H1MLJ9iP3Znh1H0av126YZI05NR9sTgP4+BsjfyKq1OXh
1qq4lsYbxqupUbVH3J82sKszY3gIhbyeBoWEkiuAXXg/zGQmKwQE0wWaD8vISXtyprgpSOYOeLLW
f0NWwi7Yz9Qzuqilgw4qGNn1l1ZJ9s2fwRMo3OsHGkXOUnKyJtqEyV7IHp4KI5OLtpU23JcW5Fer
ORQO6VdeRli6UGHHQqtXhIVgUFg0QHQOPANJv57g1ebc7XJyY8Uljl0qowgiqmYzlhyGsnEc0Bhh
hhhhnCMgI3lF516OOSAM6EcQwa73bmMratPJiCPCzgnrj545H1NZleYOtBEAmB3LOxbr0/USnU1C
EJnKOA3UjOaZYlQA2K2RPESqe+aFIFQhdxBAFACTT2Pc6dVUh2E2gRSqs0Cug8rTPs/p9dutgNwd
HLMpaXEo9M0D3I0m6dK41RgXy+joy2SIh1gTAwITQ1SGKgM5Y+A/NAdwwqD7qO0LSV6iOgxQ/LHQ
HbjQ8k7B1Q1h/OwLKfuRnQHbEEAuL7QGeRGFmTiPjw75K7ljzCTzgGSSG7yUo4ThG2tYMwHteAOj
Dktp6c4y0Th0TXJTxgMYKogJTG16ZKRIALbiLazG+pYXRxg+8Z61I4mD0KlYa6qn0kolvwJsLi+l
KDArx9+VETaVCWmTgzcTAyzRRwZEENYhC2jo/YbRGZO0uJcl1yLqMs3xYehEppKQ84VG4XjmevEP
3M8gBReQoJwA2dglIr/sdm7W2RteLgAQxy6DEdKWgr5MBG9qkKg1gbQoW7AlhQUFkgjYFMYFSwfu
DEBvPtqEacYcZGxxBezEqtCNLNnqusSFsDGrhR7RwXoYNAayUMAsLu8QC9E/ADgDQJdxfwh8zMYG
9khUiXcDLHLe9JWgnMSVU3AqjlpQJYtL75v0wOG0urE5gv3WDZmDWBZEFWGQIMhFAtLQC5UVU68R
FDLSuIvJSrzEiUqsV4yyIQ9yERI2sUBoIeiuVI6iQpKgsN2OpbF+Zz52Zk4CYno9/hpsCvReMHYS
J0DmKdHDI7FsoDpJ1NMjAdrGiLRCHjnIyE99Y6FOYJgKrzcCTEKpSsNtTFkaIwcRVR55fY3Xq6Ea
M0WILUrldHMWVYwlVaTxg78RQE4dLPRIlC0KbcKLhOB9PpCNZDRKnBTX1DERxDEyP+LuSKcKEh1o
hhzA

----Next_Part(Sun_Aug_23_17_20_53_2009_459)--
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

----Next_Part(Sun_Aug_23_17_20_53_2009_459)----
