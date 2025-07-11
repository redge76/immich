<script lang="ts">
  import { Modal, ModalBody } from '@immich/ui';
  import { mdiInformationOutline } from '@mdi/js';
  import { t } from 'svelte-i18n';
  import Icon from '../components/elements/icon.svelte';

  interface Shortcuts {
    general: ExplainedShortcut[];
    actions: ExplainedShortcut[];
  }

  interface ExplainedShortcut {
    key: string[];
    action: string;
    info?: string;
  }

  interface Props {
    onClose: () => void;
    shortcuts?: Shortcuts;
  }

  let {
    onClose,
    shortcuts = {
      general: [
        { key: ['←', '→'], action: $t('previous_or_next_photo') },
        { key: ['D', 'd'], action: $t('previous_or_next_day') },
        { key: ['M', 'm'], action: $t('previous_or_next_month') },
        { key: ['Y', 'y'], action: $t('previous_or_next_year') },
        { key: ['x'], action: $t('select') },
        { key: ['Esc'], action: $t('back_close_deselect') },
        { key: ['Ctrl', 'k'], action: $t('search_your_photos') },
        { key: ['Ctrl', '⇧', 'k'], action: $t('open_the_search_filters') },
      ],
      actions: [
        { key: ['f'], action: $t('favorite_or_unfavorite_photo') },
        { key: ['i'], action: $t('show_or_hide_info') },
        { key: ['s'], action: $t('stack_selected_photos') },
        { key: ['l'], action: $t('add_to_album') },
        { key: ['t'], action: $t('tag_assets') },
        { key: ['⇧', 'l'], action: $t('add_to_shared_album') },
        { key: ['⇧', 'a'], action: $t('archive_or_unarchive_photo') },
        { key: ['⇧', 'd'], action: $t('download') },
        { key: ['Space'], action: $t('play_or_pause_video') },
        { key: ['Del'], action: $t('trash_delete_asset'), info: $t('shift_to_permanent_delete') },
        { key: ['1', '2', '3', '4', '5', '0'], action: $t('star_rating_set_1_5_0') },
      ],
    },
  }: Props = $props();
</script>

<Modal title={$t('keyboard_shortcuts')} size="medium" {onClose}>
  <ModalBody>
    <div class="grid grid-cols-1 gap-4 px-4 pb-4 md:grid-cols-2">
      {#if shortcuts.general.length > 0}
        <div class="p-4">
          <h2>{$t('general')}</h2>
          <div class="text-sm">
            {#each shortcuts.general as shortcut (shortcut.key.join('-'))}
              <div class="grid grid-cols-[30%_70%] items-center gap-4 pt-4 text-sm">
                <div class="flex justify-self-end">
                  {#each shortcut.key as key (key)}
                    <p
                      class="me-1 flex items-center justify-center justify-self-end rounded-lg bg-immich-primary/25 p-2"
                    >
                      {key}
                    </p>
                  {/each}
                </div>
                <p class="mb-1 mt-1 flex">{shortcut.action}</p>
              </div>
            {/each}
          </div>
        </div>
      {/if}
      {#if shortcuts.actions.length > 0}
        <div class="p-4">
          <h2>{$t('actions')}</h2>
          <div class="text-sm">
            {#each shortcuts.actions as shortcut (shortcut.key.join('-'))}
              <div class="grid grid-cols-[30%_70%] items-center gap-4 pt-4 text-sm">
                <div class="flex justify-self-end">
                  {#each shortcut.key as key (key)}
                    <p
                      class="me-1 flex items-center justify-center justify-self-end rounded-lg bg-immich-primary/25 p-2"
                    >
                      {key}
                    </p>
                  {/each}
                </div>
                <div class="flex items-center gap-2">
                  <p class="mb-1 mt-1 flex">{shortcut.action}</p>
                  {#if shortcut.info}
                    <Icon path={mdiInformationOutline} title={shortcut.info} />
                  {/if}
                </div>
              </div>
            {/each}
          </div>
        </div>
      {/if}
    </div>
  </ModalBody>
</Modal>
