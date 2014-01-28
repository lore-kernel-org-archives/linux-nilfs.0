From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [static superblock discussion] Does nilfs2 do any in-place
 writes?
Date: Tue, 28 Jan 2014 13:25:14 +0400
Message-ID: <1390901114.2942.11.camel@slavad-ubuntu-12.04>
References: <1389787304.3913.28.camel@slavad-ubuntu>
	 <20140116.002353.94325733.konishi.ryusuke@lab.ntt.co.jp>
	 <1389866912.2565.44.camel@slavad-ubuntu>
	 <20140118.090008.194171715.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=wic6IHLNzKeX0Bblm0fZ3g60szznxxHpexRbun1uGsM=;
	b=WwqKwQjGjVTJkv7iaFlqxWYwt2ovmIOyfCVCajC7G3Or/tFQrNKW4i6WgXaV2a1bJQUinKOdzcC4Ki6T99puhwAiuBIREXTqjyGSCb4cqqQyxL9Jb19PvPGDXAW4kyeq;
In-Reply-To: <20140118.090008.194171715.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Ryusuke,

This is my improved vision of possible approach to change in-place
update of superblock on COW policy. I suppose that current description
includes all that we discussed previously. And we can continue to deepen
this discussion. 

Approach is based on necessity to have two areas at the begin and
at the end of a NILFS2 volume. Every such area should have capacity
is equal to segment size. The goal of these two areas is to provide
a FTL-friendly way of storing information about latest log and
modified superblock's fields by means of COW (Copy-On-Write) policy.

At the begin of a NILFS2 volume is located primary superblock area.
Primary superblock area begins from static superblock is created
during NILFS2 volume creation by means of mkfs tool. This superblock
(primary superblock) is located on 1024 bytes from the volume begin
(as it placed currently). The primary superblock leaves untouched
during filling primary superblock area by modified information.
Initial state of superblock can be rewritten at the moment of
beginning next iteration of filling of primary superblock area
(because this area lives likewise circular buffer).

------------------------------------------------------------
| Primary superblock |         Modifiable area             |
------------------------------------------------------------
|<----  4 KB  ------>|
|<-------------------- segment size ---------------------->|

On the opposite side of the volume (at the volume's end) is located
secondary (or back) superblock area. This area begins from modifiable
area and it ends with secondary superblock (as it is located currently).
Modifiable area of secondary superblock area lives likewise of
modifiable area in first superblock area.

------------------------------------------------------------
|         Modifiable area           | Secondary superblock |
------------------------------------------------------------
                                    |<------  4 KB  ------>|
|<-------------------- segment size ---------------------->|

Primary and secondary superblock areas have goal to keep copies
of super roots. And, firstly, namely these areas are used for
searching a latest log. These areas should keep as super root as
physical block of this super root's placement. Moreover, primary
and secondary superblock areas have different frequency of updating.
Secondary superblock area is updated during every umount or once
at several hours (if we have significant system uptime). Primary
superblock area is updated more frequently. The frequency of
primary superblock area's update can be based on timeout or count
of constructed segments. But, anyway, it makes sense to take into
account only full segments instead of partial segments. Maybe, it
makes sense to keep more complex combination in modifiable area:
super root + diff to superblock state + physical block of super root's
placement.

Modifiable area should have special filling policy. This policy
doesn't contradict with COW policy but it implements not in
sequential manner. Namely, modifiable area should be divided on
several groups (the count of groups can be configurable option).
Moreover, primary and secondary superblock areas would have
different values of groups count. Thereby, every group will contain
some blocks count.

-------------------------------------------------------------
| Group1 | Group2 | Group3 |          ****         | GroupN |
-------------------------------------------------------------
|<-------------------- Modifiable area -------------------->|

Saving blocks are distributed between groups by means of policy
that every next block should be saved in next group on every
iteration. If all groups in modifiable area have equal count of
saved blocks then it begins the next iteration which starts from
the first group.

FIRST ITERATION [A phase]:

(1) first block
-------------------------------------------------------------
|A1|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
-------------------------------------------------------------
|<-- Group1 -->|<-- Group2 -->|<-- ****** -->|<-- GroupN -->|

(2) second block
-------------------------------------------------------------
|A1|  |  |  |  |A2|  |  |  |  |  |  |  |  |  |  |  |  |  |  |
-------------------------------------------------------------
|<-- Group1 -->|<-- Group2 -->|<-- ****** -->|<-- GroupN -->|

(N) Nth block
-------------------------------------------------------------
|A1|  |  |  |  |A2|  |  |  |  |A3|  |  |  |  |An|  |  |  |  |
-------------------------------------------------------------
|<-- Group1 -->|<-- Group2 -->|<-- ****** -->|<-- GroupN -->|

SECOND ITERATION [B phase]:

-------------------------------------------------------------
|A1|B1|  |  |  |A2|B2|  |  |  |A3|B3|  |  |  |An|Bn|  |  |  |
-------------------------------------------------------------
|<-- Group1 -->|<-- Group2 -->|<-- ****** -->|<-- GroupN -->|

Nth ITERATION [E phase]:

-------------------------------------------------------------
|A1|B1|C1|D1|E1|A2|B2|C2|D2|E2|A3|B3|C3|D3|E3|An|Bn|Cn|Dn|En|
-------------------------------------------------------------
|<-- Group1 -->|<-- Group2 -->|<-- ****** -->|<-- GroupN -->|

Finally, when modifiable area is completely filled then it is
possible to discard area's content and to begin filling iterations
again. We will have two modifiable areas are filling with
different frequencies and some state of replication of
information. Thereby, it provides basis for safe and independent
discarding of modifiable areas.

The special filling policy has goal to provide a basis for
efficient search. Namely, first group contains blocks differ by
some period from each other. We have such sequence during saving:
[A1,A2,A3,..,An], [B1,B2,B3,..,Bn], ..., [E1,E2,E3,..,En]. But
first group will contain (A1,B1,C1,D1,E1). Thereby, passing
item-by-item through first group means jumping with some period.
Moreover, in the case of some failure it is possible to start the
searching from any group (with decreasing search efficiency).
It needs to take into account magic signature, header checksum and
timestamps during comparison of items in group. It provides opportunity
to distinguish valid blocks from empty and invalid ones and to
distinguish older blocks from latest ones.

Searching in dedicated area gives opportunity to use read-ahead
technique. Moreover, if group contains many items then it is
possible to increase step between current and next items during
search. For example, it is possible to use such sequence of steps
during searching: 0, 1, 3, 5, 7, and so on. If we have found
latest item in first group, for example, then it is possible
to find a latest item in he whole sequence by means of jumping on
group period (count of blocks in a group).

Two modifiable areas are filled with different frequencies and
it gives opportunity to use special searching algorithm. Such algorithm
can use, for example, secondary superblock area for rough,
preliminary search (because this modifiable area is changed rarely).
Then, further, algorithm can continue search in first superblock
area (because this modifiable area is changed more frequently).
Moreover, segctor thread has knowledge about all dirty files and it can
predict, theoretically, how many segments will be constructed.
Thereby, it is possible to save in items of modifiable area's groups
such prediction in the form of hint that it can be used during search
for improving search algorithm efficiency.

With the best regards,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
