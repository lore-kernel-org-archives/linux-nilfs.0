From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Write hang on ARM based target
Date: Fri, 19 Jun 2009 10:47:31 +0900 (JST)
Message-ID: <20090619.104731.99018736.ryusuke@osrg.net>
References: <20090612.132344.17157054.ryusuke@osrg.net>
	<20090619.033642.32757627.ryusuke@osrg.net>
	<BAEFA5609CC3AB4BAE1625CAD4C27E5C01900FAC@tdpost.td.tandbergdata.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Fri_Jun_19_10_47_31_2009_170)--"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <BAEFA5609CC3AB4BAE1625CAD4C27E5C01900FAC-qPLjlnsG5hmCmmEZ8mJCX5vx1ZQ4fP860E9HWUfgJXw@public.gmane.org>
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
To: WDunphy-/3AnZwnt+WyVkR+q5Y5grQ@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

----Next_Part(Fri_Jun_19_10_47_31_2009_170)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi,
On Thu, 18 Jun 2009 13:48:56 -0600, "Dunphy, Bill" wrote:
> Tried applying patch to latest git pull as well as 2.0.12 and 2.0.14 and
> experienced the following patch issue:
> 
> $ patch -p1 <your.patch 
> (Stripping trailing CRs from patch.)
> patching file fs/dat.c
> (Stripping trailing CRs from patch.)
> patching file fs/segment.c
> patch: **** malformed patch at line 50: @@ -2056,12 +2043,11 @@ static
> void nilfs_end_page_io(struct page *page, int err)
> 
> I could attempt to do by hand but decided to let you chime in first.
> 
> Thoughts? 
> 
> Bill

Hmm, strange.

I will attach the compressed one.  It is against the latest git, but
will be also applicable to v2.0.14.

 $ cd nilfs2-module
 $ bunzip -c xxx/nilfs2-fix-hang-after-bio_alloc-failed.patch.bz2 | patch -p1

How does this go ?

Ryusuke Konishi

----Next_Part(Fri_Jun_19_10_47_31_2009_170)--
Content-Type: Application/Octet-Stream
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="nilfs2-fix-hang-after-bio_alloc-failed.patch.bz2"

QlpoOTFBWSZTWd3wpkEAAp7fgGgwc3//u+sv3sS/7//uUATY9ljbGtoGgpQJRCEPUaaNR6jRo0aG
JhPUAaDIBtTEaHDTTIxGE0wEMAmmEYJiZDTI0NAJTJEJpDTU2p+qeQamjR6QGhpoMjQGjIyaHDTT
IxGE0wEMAmmEYJiZDTI0NAJEggmmEBBoBQaMgAGEAD1PUepWgJCIRALXyMEoQDBDTlykxCGKCGm4
cNjHKcoTYJJt7vZl2e1OiVuajpWtlXKBK2Wtrm7s0v5Rzx4ws+11bDWO3POvkZVGRaSlssSsVpMY
HBITANhvYEL+vdl+eR8IYqe4/IhQGVE22OpqlGgvX72B5kD+oN97G7U+qvALDNDBs1tcpATE88lm
+bluOunJIq1tKnPdVZSAsEtxGlVw5rgfbjmgIJ0LO2LTyiwk7DAegeIXmJmTLLmmRGBtzkpqi85D
qiSdOpD2aDMZcXbNqOHevwcPYg9qXrzSHHnBhVBhwbqmU1GOX2Q4anYrZowiuEZxFJMRkhUyqowa
OCSZfuUmJR0300NnXa3ZdYqaQ5NZIE3US6CjAgpmOkNtYTVVdajCVlhVlMODxDoxyogmIGbhag7E
tyoU8hmsyNPnJAek+g2B6rhjHAePpynGdxFp4AkoI4nVpZd91rNEksk2WPhuuxSZdAVRYKFdNE0r
s+YKCjboTiStxmW0W+by8wrqPXUFm7WbojmEeoYwMxEI4gN4GHRwHV0fqp+9NxuilE76hij+3Lpo
qPfNRkbJV/LOXvxP4sHp0xV05RUZOZU5qbYCQcxl5ak2jC0LbCozEY2F6Sahgi5EXXunoW4KH1lb
8ksLbgxPVmgXi0i887siZb/zNYYkrRMsgOQdSIiETq65NYPihRL1pjKmdjTwcDdljLDnCpWTHAYg
e4X29p1DqZn31JUJ6qonYXIgOwCRgOrd1oNMlI6vayYTDE0/EMLTWLglYfUU4ZnI6ec2HjOFg14H
Iw2FVI4kHWrEl3XpWyVE0xiZ2hNVtJVCZeMZO4F4Bpg82jMWkcYfk4clejQVlEyh9LhTRQ2DGxbD
Q5CKHUFh1ySJk0jcU6QN4GGc4bkIzkVA2C4oQUvPgUIYdOcgusNCwnTuVNXW40ElCYNyTfDFEZm+
godYbw6d5wEGa7DYQjqgMjVaF2g1fhaGlrL+fiEg0ulrD2KimTBGYdnvrFH+hU6EawIDkFsjDYLm
kbYgrtVxipSoecHaiaVChcEEAW9GqHvZKSC1G2zhMqeAMqFA1CbBbe8t6NtQklu5MUxegJ41LCoF
v2GRYcTjvzy0LEw6O6DCBJlJJGyEIW1GqNOttRGEGG2lG3BIyJwUDIic+pNQszcY5+GfZlukQLV3
rzoLWIMA18sQROcllJgzpA7oIEpsRQ0NC85iQZnwBvDRMXF7sjUwzYmoLchaeIWi/GSS1CUOtEig
k223zxZpWskEBejXVFxd176JUoZFwFgLUK45sGu0GEAYJLfgMqaHewv1cwsiqLX6SZJYmFSCZLEG
IsDJ+b4Jyg/8XckU4UJDd8KZBA==

----Next_Part(Fri_Jun_19_10_47_31_2009_170)--
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

----Next_Part(Fri_Jun_19_10_47_31_2009_170)----
