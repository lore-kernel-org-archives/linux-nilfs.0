From: Tom Talpey <tom@talpey.com>
Subject: Re: [PATCH v5 09/23] cifs: Convert wdata_alloc_and_fillpages() to use
 filemap_get_folios_tag()
Date: Thu, 12 Jan 2023 22:03:27 -0500
Message-ID: <c2b5b3b4-d5d0-bf35-d659-b2328689073a@talpey.com>
References: <20230104211448.4804-1-vishal.moola@gmail.com>
 <20230104211448.4804-10-vishal.moola@gmail.com>
 <CAOzc2pw9WCgHyA2epbz5=HEWN4bFzD4C7zL2452J_egv7iSLrw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Language: en-US
In-Reply-To: <CAOzc2pw9WCgHyA2epbz5=HEWN4bFzD4C7zL2452J_egv7iSLrw@mail.gmail.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Vishal Moola <vishal.moola@gmail.com>, linux-fsdevel@vger.kernel.org, pc@cjr.nz
Cc: linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-nilfs@vger.kernel.org, linux-mm@kvack.org

This code would be a lot more readable if it had fewer goto's.
The goto out's are ok but the again and add_more are easily
eliminated.

Two possibilities...

On 1/12/2023 12:19 PM, Vishal Moola wrote:
> On Wed, Jan 4, 2023 at 1:15 PM Vishal Moola (Oracle)
> <vishal.moola@gmail.com> wrote:
>>
>> This is in preparation for the removal of find_get_pages_range_tag(). Now also
>> supports the use of large folios.
>>
>> Since tofind might be larger than the max number of folios in a
>> folio_batch (15), we loop through filling in wdata->pages pulling more
>> batches until we either reach tofind pages or run out of folios.
>>
>> This function may not return all pages in the last found folio before
>> tofind pages are reached.
>>
>> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
>> ---
>>   fs/cifs/file.c | 32 +++++++++++++++++++++++++++++---
>>   1 file changed, 29 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index 22dfc1f8b4f1..8cdd2f67af24 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -2527,14 +2527,40 @@ wdata_alloc_and_fillpages(pgoff_t tofind, struct address_space *mapping,
>>                            unsigned int *found_pages)
>>   {
>>          struct cifs_writedata *wdata;
>> -
>> +       struct folio_batch fbatch;
>> +       unsigned int i, idx, p, nr;
>>          wdata = cifs_writedata_alloc((unsigned int)tofind,
>>                                       cifs_writev_complete);
>>          if (!wdata)
>>                  return NULL;
>>
>> -       *found_pages = find_get_pages_range_tag(mapping, index, end,
>> -                               PAGECACHE_TAG_DIRTY, tofind, wdata->pages);
>> +       folio_batch_init(&fbatch);
>> +       *found_pages = 0;
>> +


This is really just the top of a while loop:

   while (nr = filemap_get_folios_tag(...)) {

>> +again:
>> +       nr = filemap_get_folios_tag(mapping, index, end,
>> +                               PAGECACHE_TAG_DIRTY, &fbatch);
>> +       if (!nr)
>> +               goto out; /* No dirty pages left in the range */
>> +
>> +       for (i = 0; i < nr; i++) {
>> +               struct folio *folio = fbatch.folios[i];
>> +
>> +               idx = 0;
>> +               p = folio_nr_pages(folio);

And this is a "do {"

>> +add_more:
>> +               wdata->pages[*found_pages] = folio_page(folio, idx);
>> +               folio_get(folio);
>> +               if (++*found_pages == tofind) {
>> +                       folio_batch_release(&fbatch);
>> +                       goto out;
>> +               }
>> +               if (++idx < p)
>> +                       goto add_more;

To here "} while (++idx < p);"

>> +       }
>> +       folio_batch_release(&fbatch);
>> +       goto again;

End while "}"

>> +out:
>>          return wdata;
>>   }
>>
>> --
>> 2.38.1
>>
> 
> Could someone review this cifs patch, please? This is one of the
> 2 remaining patches that need to be looked at in the series.

It's otherwise ok.

Tom.
> 
